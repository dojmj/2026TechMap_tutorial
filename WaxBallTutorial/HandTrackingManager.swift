//
//  HandTrackingManager.swift
//  WaxBallTutorial
//
//  Created by 조민지 on 8/14/26.
//

import Foundation
import ARKit

@MainActor
final class HandTrackingManager {
    
    // MARK: - ARKit
    
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()
    
    
    // MARK: - Start Tracking
    
    func startTracking() async {
        
        do {
            try await session.run([
                handTracking
            ])
            
            print("Hand Tracking started")
            
            await processHandUpdates()
            
        } catch {
            print("Failed to start Hand Tracking: \(error)")
        }
    }
    
    
    // MARK: - Hand Updates
    
    private func processHandUpdates() async {
        
        for await update in handTracking.anchorUpdates {
            
            let handAnchor = update.anchor
            
            // Tracking되지 않는 손은 처리하지 않음
            guard handAnchor.isTracked else {
                continue
            }
            
            // 왼손 / 오른손 구분
            switch handAnchor.chirality {
                
            case .left:
                print("👈 Left hand detected")
                
            case .right:
                print("👉 Right hand detected")
                
            @unknown default:
                break
            }
            
            
            // MARK: - Hand Skeleton
            
            guard let skeleton = handAnchor.handSkeleton else {
                continue
            }
            
            
            // MARK: - Step 03
            // Finger Joint Position
            
            let thumbPosition = getJointPosition(
                skeleton.joint(.thumbTip),
                from: handAnchor
            )
            
            let indexPosition = getJointPosition(
                skeleton.joint(.indexFingerTip),
                from: handAnchor
            )
            
            let middlePosition = getJointPosition(
                skeleton.joint(.middleFingerTip),
                from: handAnchor
            )
            
            let ringPosition = getJointPosition(
                skeleton.joint(.ringFingerTip),
                from: handAnchor
            )
            
            let littlePosition = getJointPosition(
                skeleton.joint(.littleFingerTip),
                from: handAnchor
            )
            
            let wristPosition = getJointPosition(
                skeleton.joint(.wrist),
                from: handAnchor
            )
            
            
            // MARK: - Step 04
            // Finger Distance
            
            let distances = FingerDistances(
                thumb: simd_distance(
                    thumbPosition,
                    wristPosition
                ),
                
                index: simd_distance(
                    indexPosition,
                    wristPosition
                ),
                
                middle: simd_distance(
                    middlePosition,
                    wristPosition
                ),
                
                ring: simd_distance(
                    ringPosition,
                    wristPosition
                ),
                
                little: simd_distance(
                    littlePosition,
                    wristPosition
                )
            )
            
            
            print("""
            
            ===== Finger Distances =====
            
            Thumb : \(distances.thumb)
            Index : \(distances.index)
            Middle: \(distances.middle)
            Ring  : \(distances.ring)
            Little: \(distances.little)
            
            =============================
            """)
            
            
            // MARK: - Step 05
            // Finger Closure
            
            let closures = calculateFingerClosures(
                distances: distances
            )
            
            
            print("""
            
            ===== Finger Closure =====
            
            Thumb : \(closures.thumb)
            Index : \(closures.index)
            Middle: \(closures.middle)
            Ring  : \(closures.ring)
            Little: \(closures.little)
            
            ===========================
            """)
        }
    }
    
    
    // MARK: - Joint Position
    
    private func getJointPosition(
        _ joint: HandSkeleton.Joint,
        from handAnchor: HandAnchor
    ) -> SIMD3<Float> {
        
        let jointTransform =
            handAnchor.originFromAnchorTransform
            * joint.anchorFromJointTransform
        
        return SIMD3<Float>(
            jointTransform.columns.3.x,
            jointTransform.columns.3.y,
            jointTransform.columns.3.z
        )
    }
}
