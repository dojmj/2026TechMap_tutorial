private var stages: [Entity] = []
private var originalScales: [SIMD3<Float>] = []
private var currentStageIndex = 0

func connect(to entities: [Entity]) {
    guard entities.count == 4 else {
        return
    }

    stages = entities
    originalScales = entities.map { entity in
        entity.transform.scale
    }

    showStage(at: currentStageIndex)
}
