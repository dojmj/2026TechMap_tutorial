# WaxBall Hand Tracking

Apple Vision Pro의 Hand Skeleton 데이터를 사용해 양손으로 왁뿌볼을 누르고 단계적으로 부수는 인터랙션을 만듭니다.

## Overview

이 튜토리얼은 visionOS 프로젝트 생성부터 Hand Tracking, Joint Position, 손가락 거리, `graspProgress`, RealityKit Entity 변형과 양손 파괴 인터랙션까지 단계적으로 설명합니다.

전체 학습 흐름은 다음과 같습니다.

1. visionOS 프로젝트와 Immersive Space를 준비합니다.
2. ARKit의 Hand Tracking을 시작합니다.
3. Hand Skeleton에서 필요한 Joint Position을 가져옵니다.
4. 손가락 끝과 손목 사이의 거리를 계산합니다.
5. 거리값을 `graspProgress`로 변환합니다.
6. Progress를 RealityKit Entity의 형태에 연결합니다.
7. 파괴 정도가 다른 네 모델을 단계적으로 전환합니다.
8. 왼손과 오른손의 값을 결합해 양손 Interaction을 완성합니다.
