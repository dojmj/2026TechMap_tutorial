//
//  02-HandTracking-01.swift.swift
//  
//
//  Created by Kimseoyeon on 8/18/26.
//

import Foundation
import ARKit

@MainActor
final class HandTrackingManager {

    let session = ARKitSession()
    let handTracking = HandTrackingProvider()

    func startTracking() async {
        do {
            try await session.run([
                handTracking
            ])

            await processHandUpdates()

        } catch {
            print("Hand tracking failed: \(error)")
        }
    }

    private func processHandUpdates() async {

        for await update in handTracking.anchorUpdates {

            let handAnchor = update.anchor

            guard handAnchor.isTracked else {
                continue
            }

            guard let skeleton = handAnchor.handSkeleton else {
                continue
            }

            let thumb = skeleton.joint(.thumbTip)
            let index = skeleton.joint(.indexFingerTip)
            let middle = skeleton.joint(.middleFingerTip)
            let ring = skeleton.joint(.ringFingerTip)
            let little = skeleton.joint(.littleFingerTip)
            let wrist = skeleton.joint(.wrist)

            let thumbPosition = getJointPosition(
                thumb,
                from: handAnchor
            )

            let indexPosition = getJointPosition(
                index,
                from: handAnchor
            )

            let middlePosition = getJointPosition(
                middle,
                from: handAnchor
            )

            let ringPosition = getJointPosition(
                ring,
                from: handAnchor
            )

            let littlePosition = getJointPosition(
                little,
                from: handAnchor
            )

            let wristPosition = getJointPosition(
                wrist,
                from: handAnchor
            )
        }
    }

    private func getJointPosition(
        _ joint: HandSkeleton.Joint,
        from handAnchor: HandAnchor
    ) -> SIMD3<Float> {

        let worldTransform =
            handAnchor.originFromAnchorTransform
            * joint.anchorFromJointTransform

        return SIMD3<Float>(
            worldTransform.columns.3.x,
            worldTransform.columns.3.y,
            worldTransform.columns.3.z
        )
    }
}
