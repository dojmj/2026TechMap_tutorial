import Foundation
import ARKit

@MainActor
final class HandTrackingManager {

    let session = ARKitSession()
    let handTracking = HandTrackingProvider()
    let graspController = GraspController()
    private let graspDetector = GraspDetector()
    
    private var leftGraspProgress: Float = 0
    private var rightGraspProgress: Float = 0

    func startTracking() async {
        guard HandTrackingProvider.isSupported else {
            print("이 실행 환경은 Hand Tracking을 지원하지 않습니다.")
            return
        }
        do {
            try await session.run([
                handTracking
            ])

            print("✅ Hand tracking started")

            await processHandUpdates()

        } catch {
            print("❌ Hand tracking failed: \(error)")
        }
    }

    private func processHandUpdates() async {

        for await update in handTracking.anchorUpdates {

            let handAnchor = update.anchor

            guard handAnchor.isTracked else {
                setGraspProgress(
                    0,
                    for: handAnchor.chirality
                )
                updateGraspSphere()
                continue
            }

            guard let skeleton = handAnchor.handSkeleton else {
                setGraspProgress(
                    0,
                    for: handAnchor.chirality
                )
                updateGraspSphere()
                continue
            }

            // MARK: - Get Hand Joints

            let thumb = skeleton.joint(.thumbTip)
            let index = skeleton.joint(.indexFingerTip)
            let middle = skeleton.joint(.middleFingerTip)
            let ring = skeleton.joint(.ringFingerTip)
            let little = skeleton.joint(.littleFingerTip)
            let wrist = skeleton.joint(.wrist)

            // MARK: - Get World Positions

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
            
            let indexDistance = graspDetector.fingerDistance(
                from: indexPosition,
                to: wristPosition
            )
            print("검지와 손목 사이 거리:", indexDistance)
            
            let indexProgress = graspDetector.closureProgress(
                distance: indexDistance
            )

            print("검지 접힘 정도:", indexProgress)
            
            let graspProgress = graspDetector.graspProgress(
                thumb: thumbPosition,
                index: indexPosition,
                middle: middlePosition,
                ring: ringPosition,
                little: littlePosition,
                wrist: wristPosition
            )

            print("\(handAnchor.chirality) graspProgress:", graspProgress)

            setGraspProgress(
                graspProgress,
                for: handAnchor.chirality
            )

            updateGraspSphere()

            // MARK: - Debug

            print("""
            ---
            Hand: \(handAnchor.chirality)

            Thumb:  \(thumbPosition)
            Index:  \(indexPosition)
            Middle: \(middlePosition)
            Ring:   \(ringPosition)
            Little: \(littlePosition)
            Wrist:  \(wristPosition)
            ---
            """)
        }
    }

    private func setGraspProgress(
        _ progress: Float,
        for chirality: HandAnchor.Chirality
    ) {
        switch chirality {
        case .left:
            leftGraspProgress = progress
        case .right:
            rightGraspProgress = progress
        }
    }

    private func updateGraspSphere() {
        let currentGraspProgress = max(
            leftGraspProgress,
            rightGraspProgress
        )

        print("현재 graspProgress:", currentGraspProgress)

        graspController.update(
            graspProgress: currentGraspProgress
        )
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
