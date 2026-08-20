func update(graspProgress: Float) {
    guard stages.count == 4 else {
        return
    }

    let progress = min(max(graspProgress, 0), 1)
    let nextStageIndex = stageIndex(for: progress)

    currentStageIndex = max(
        currentStageIndex,
        nextStageIndex
    )

    showStage(at: currentStageIndex)
}

private func showStage(at selectedIndex: Int) {
    for (index, entity) in stages.enumerated() {
        entity.isEnabled = index == selectedIndex
    }
}
