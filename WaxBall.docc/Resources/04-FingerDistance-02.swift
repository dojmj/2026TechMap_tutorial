//
//  04-FingerDistance-02.swift
//

import Foundation
import ARKit
import simd

func calculateFingerDistances(
    handAnchor: HandAnchor,
    skeleton: HandSkeleton
) -> [String: Float] {
    
    let wristJoint = skeleton.joint(.wrist)
    
    let thumbTip = skeleton.joint(.thumbTip)
    let indexTip = skeleton.joint(.indexFingerTip)
    let middleTip = skeleton.joint(.middleFingerTip)
    let ringTip = skeleton.joint(.ringFingerTip)
    let littleTip = skeleton.joint(.littleFingerTip)
    
    let wristPosition = getJointPosition(
        wristJoint,
        from: handAnchor
    )
    
    let thumbPosition = getJointPosition(
        thumbTip,
        from: handAnchor
    )
    
    let indexPosition = getJointPosition(
        indexTip,
        from: handAnchor
    )
    
    let middlePosition = getJointPosition(
        middleTip,
        from: handAnchor
    )
    
    let ringPosition = getJointPosition(
        ringTip,
        from: handAnchor
    )
    
    let littlePosition = getJointPosition(
        littleTip,
        from: handAnchor
    )
    
    return [
        "Thumb": simd_distance(thumbPosition, wristPosition),
        "Index": simd_distance(indexPosition, wristPosition),
        "Middle": simd_distance(middlePosition, wristPosition),
        "Ring": simd_distance(ringPosition, wristPosition),
        "Little": simd_distance(littlePosition, wristPosition)
    ]
}
