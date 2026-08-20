import simd

struct GraspDetector {
    func fingerDistance(
        from fingertip: SIMD3<Float>,
        to wrist: SIMD3<Float>
    ) -> Float {
        simd_distance(fingertip, wrist)
    }
}
