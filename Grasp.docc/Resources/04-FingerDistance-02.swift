// HandTrackingManager 내부

private let graspDetector = GraspDetector()

// processHandUpdates()에서 Joint Position을 계산한 다음 실행합니다.
let indexDistance = graspDetector.fingerDistance(
    from: indexPosition,
    to: wristPosition
)

print("검지와 손목 사이 거리: \(indexDistance)")
