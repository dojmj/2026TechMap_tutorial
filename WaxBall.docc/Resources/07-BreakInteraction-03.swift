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
