// HandTrackingManager 내부

let waxBallController = WaxBallController()

// processHandUpdates()에서 추적 상태를 확인한 다음 실행합니다.
guard handAnchor.chirality == .right else {
    continue
}

// graspProgress를 계산한 다음 왁뿌볼에 전달합니다.
waxBallController.update(
    graspProgress: graspProgress
)
