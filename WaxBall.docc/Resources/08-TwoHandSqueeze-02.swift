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

// 한 손의 graspProgress를 계산한 다음 실행합니다.
setGraspProgress(
    graspProgress,
    for: handAnchor.chirality
)
