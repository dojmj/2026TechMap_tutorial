import simd

struct GraspDetector {
    func fingerDistance(
        from fingertip: SIMD3<Float>,
        to wrist: SIMD3<Float>
    ) -> Float {
        simd_distance(fingertip, wrist)
    }

    func closureProgress(distance: Float) -> Float {
        let closedDistance: Float = 0.08
        let openDistance: Float = 0.18

        let progress =
            (openDistance - distance)
            / (openDistance - closedDistance)

        return min(max(progress, 0), 1)
    }
}
