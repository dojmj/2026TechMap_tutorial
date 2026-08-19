//
//  FingerClosure.swift
//  WaxBallTutorial
//
//  Created by Kimseoyeon on 8/19/26.
//

import Foundation

struct FingerClosures {
    let thumb: Float
    let index: Float
    let middle: Float
    let ring: Float
    let little: Float
}

func calculateClosure(
    currentDistance: Float,
    openDistance: Float,
    closedDistance: Float
) -> Float {
    
    let range = openDistance - closedDistance
    
    guard range > 0 else {
        return 0
    }
    
    let closure =
        (openDistance - currentDistance) / range
    
    return min(max(closure, 0.0), 1.0)
}

func calculateFingerClosures(
    distances: FingerDistances
) -> FingerClosures {
    
    return FingerClosures(
        thumb: calculateClosure(
            currentDistance: distances.thumb,
            openDistance: 0.12,
            closedDistance: 0.05
        ),
        
        index: calculateClosure(
            currentDistance: distances.index,
            openDistance: 0.15,
            closedDistance: 0.05
        ),
        
        middle: calculateClosure(
            currentDistance: distances.middle,
            openDistance: 0.16,
            closedDistance: 0.06
        ),
        
        ring: calculateClosure(
            currentDistance: distances.ring,
            openDistance: 0.15,
            closedDistance: 0.06
        ),
        
        little: calculateClosure(
            currentDistance: distances.little,
            openDistance: 0.12,
            closedDistance: 0.05
        )
    )
}
