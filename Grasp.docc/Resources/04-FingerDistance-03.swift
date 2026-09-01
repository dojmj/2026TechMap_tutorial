// processHandUpdates()에서 Joint Position을 계산한 다음 실행합니다.

let thumbDistance = graspDetector.fingerDistance(
    from: thumbPosition,
    to: wristPosition
)

let indexDistance = graspDetector.fingerDistance(
    from: indexPosition,
    to: wristPosition
)

let middleDistance = graspDetector.fingerDistance(
    from: middlePosition,
    to: wristPosition
)

let ringDistance = graspDetector.fingerDistance(
    from: ringPosition,
    to: wristPosition
)

let littleDistance = graspDetector.fingerDistance(
    from: littlePosition,
    to: wristPosition
)

print("""
Thumb:  \(thumbDistance)
Index:  \(indexDistance)
Middle: \(middleDistance)
Ring:   \(ringDistance)
Little: \(littleDistance)
""")
