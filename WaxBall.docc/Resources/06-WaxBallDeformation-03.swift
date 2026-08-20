// ImmersiveView의 RealityView 내부

if let butterbar = try? await Entity(
    named: "butterbar1"
) {
    handTrackingManager.waxBallController.connect(
        to: butterbar
    )

    content.add(butterbar)
}
