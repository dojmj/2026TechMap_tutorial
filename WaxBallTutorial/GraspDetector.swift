//
//  GraspDetector.swift
//  WaxBallTutorial
//
//  Created by Kimseoyeon on 8/18/26.
//

import simd

struct GraspDetector {
    func fingerDistance(
        from fingertip: SIMD3<Float>,
        to wrist: SIMD3<Float>
    ) -> Float {
        //여기서 거리 계산하고 반환
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
    
    func graspProgress(
        thumb: SIMD3<Float>,
        index: SIMD3<Float>,
        middle: SIMD3<Float>,
        ring: SIMD3<Float>,
        little: SIMD3<Float>,
        wrist: SIMD3<Float>
    ) -> Float {
        let thumbProgress = closureProgress(
            distance: fingerDistance(from: thumb, to: wrist)
        )

        let indexProgress = closureProgress(
            distance: fingerDistance(from: index, to: wrist)
        )

        let middleProgress = closureProgress(
            distance: fingerDistance(from: middle, to: wrist)
        )

        let ringProgress = closureProgress(
            distance: fingerDistance(from: ring, to: wrist)
        )

        let littleProgress = closureProgress(
            distance: fingerDistance(from: little, to: wrist)
        )

        return (
            thumbProgress
            + indexProgress
            + middleProgress
            + ringProgress
            + littleProgress
        ) / 5
    }
    
}
