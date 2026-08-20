private func updateWaxBall() {
    let twoHandProgress = min(
        leftGraspProgress,
        rightGraspProgress
    )

    print("양손 graspProgress: \(twoHandProgress)")

    waxBallController.update(
        graspProgress: twoHandProgress
    )
}
