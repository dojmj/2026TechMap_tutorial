// HandTrackingManager 내부

private let graspDetector = GraspDetector()

// processHandUpdates()에서 Joint Position을 계산한 다음 실행합니다.
let graspProgress = graspDetector.graspProgress(
    thumb: thumbPosition,
    index: indexPosition,
    middle: middlePosition,
    ring: ringPosition,
    little: littlePosition,
    wrist: wristPosition
)

print("\(handAnchor.chirality) graspProgress: \(graspProgress)")
