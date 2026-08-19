//
//  04-FingerDistance-01.swift
//

import Foundation
import simd

func distanceBetween(
    _ pointA: SIMD3<Float>,
    _ pointB: SIMD3<Float>
) -> Float {
    
    simd_distance(pointA, pointB)
}
