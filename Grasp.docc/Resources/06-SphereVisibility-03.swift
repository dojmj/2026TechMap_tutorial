// HandTrackingManager 내부

let graspController = GraspController()

private var leftGraspProgress: Float = 0
private var rightGraspProgress: Float = 0

// processHandUpdates()에서 graspProgress를 계산한 다음 실행합니다.
setGraspProgress(graspProgress, for: handAnchor.chirality)
updateGraspSphere()

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

    print("current graspProgress:", currentGraspProgress)

    graspController.update(
        graspProgress: currentGraspProgress
    )
}
