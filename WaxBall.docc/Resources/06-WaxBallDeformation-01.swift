import RealityKit

@MainActor
final class WaxBallController {
    private var waxBall: Entity?
    private var originalScale = SIMD3<Float>(repeating: 1)

    func connect(to entity: Entity) {
        waxBall = entity
        originalScale = entity.transform.scale
    }
}
