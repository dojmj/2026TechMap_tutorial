// ImmersiveView의 RealityView 내부

let stageNames = [
    "butterbar1",
    "butterbar2",
    "butterbar3",
    "butterbar4"
]

do {
    var stages: [Entity] = []

    for name in stageNames {
        let stage = try await Entity(named: name)
        stages.append(stage)
        content.add(stage)
    }

    handTrackingManager.waxBallController.connect(
        to: stages
    )
} catch {
    print("왁뿌볼 모델을 불러오지 못했습니다: \(error)")
}
