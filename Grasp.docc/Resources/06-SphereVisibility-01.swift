import RealityKit

@MainActor
final class GraspController {
    private let hiddenThreshold: Float = 0.8
    private var sphere: Entity?

    func connect(to sphere: Entity) {
        self.sphere = sphere
        sphere.isEnabled = true
    }

    func update(graspProgress: Float) {
        let progress = min(max(graspProgress, 0), 1)
        sphere?.isEnabled = progress < hiddenThreshold
    }
}
