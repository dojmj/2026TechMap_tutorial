guard handAnchor.isTracked else {
    setGraspProgress(
        0,
        for: handAnchor.chirality
    )

    updateWaxBall()
    continue
}

guard let skeleton = handAnchor.handSkeleton else {
    setGraspProgress(
        0,
        for: handAnchor.chirality
    )

    updateWaxBall()
    continue
}
