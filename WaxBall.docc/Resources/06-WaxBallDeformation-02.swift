func update(graspProgress: Float) {
    guard let waxBall else {
        return
    }

    let progress = min(max(graspProgress, 0), 1)

    let deformation = SIMD3<Float>(
        1 + progress * 0.15,
        1 - progress * 0.35,
        1 + progress * 0.15
    )

    waxBall.transform.scale = originalScale * deformation
}
