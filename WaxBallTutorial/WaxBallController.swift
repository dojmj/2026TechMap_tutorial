//
//  WaxBallController.swift
//  WaxBallTutorial
//
//  Created by Kimseoyeon on 8/18/26.
//

import RealityKit

@MainActor
final class WaxBallController {
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

    func update(graspProgress: Float) {
        guard stages.count == 4 else {
            return
        }

        let progress = min(max(graspProgress, 0), 1)
        let nextStageIndex = stageIndex(for: progress)

        // 한 번 도달한 파괴 단계는 손을 펼쳐도 되돌아가지 않습니다.
        currentStageIndex = max(
            currentStageIndex,
            nextStageIndex
        )

        showStage(at: currentStageIndex)

        let deformation = SIMD3<Float>(
            1 + progress * 0.15,
            1 - progress * 0.35,
            1 + progress * 0.15
        )

        stages[currentStageIndex].transform.scale =
            originalScales[currentStageIndex] * deformation
    }

    private func stageIndex(for progress: Float) -> Int {
        if progress >= 0.8 {
            return 3
        }

        if progress >= 0.6 {
            return 2
        }

        if progress >= 0.4 {
            return 1
        }

        return 0
    }

    private func showStage(at selectedIndex: Int) {
        for (index, entity) in stages.enumerated() {
            entity.isEnabled = index == selectedIndex
        }
    }
}
