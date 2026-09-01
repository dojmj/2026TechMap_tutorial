// processHandUpdates() 내부

guard handAnchor.isTracked else {
    setGraspProgress(0, for: handAnchor.chirality)
    updateGraspSphere()
    continue
}

guard let skeleton = handAnchor.handSkeleton else {
    setGraspProgress(0, for: handAnchor.chirality)
    updateGraspSphere()
    continue
}
