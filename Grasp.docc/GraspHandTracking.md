# Grasp Hand Tracking

Apple Vision Pro의 Hand Skeleton 데이터를 사용해 손을 쥐는 정도를 계산하고, RealityKit Sphere의 표시 여부에 연결합니다.

## Overview

이 튜토리얼의 학습 목표는 Hand Tracking으로 손가락 Joint 정보를 얻고, 그 정보를 손을 쥐는 정도인 `graspProgress`로 바꾼 다음, 그 값을 RealityKit Entity의 표시 여부에 연결하는 흐름을 이해하는 것입니다.

각 단계에서는 코드를 붙여 넣는 것만 목표로 하지 않습니다. 어떤 파일을 수정하는지, 새로 추가하는 코드인지 기존 코드를 바꾸는 것인지, 실행했을 때 무엇을 확인해야 하는지 함께 확인합니다.

전체 학습 흐름은 다음과 같습니다.

1. visionOS 프로젝트와 Immersive Space를 준비합니다.
2. ARKit의 Hand Tracking을 시작합니다.
3. Hand Skeleton에서 필요한 Joint Position을 가져옵니다.
4. 손가락 끝과 손목 사이의 거리를 계산합니다.
5. 거리값을 `graspProgress`로 변환합니다.
6. `graspProgress`가 threshold 이상이면 Sphere를 숨기고, threshold 아래면 다시 표시합니다.
