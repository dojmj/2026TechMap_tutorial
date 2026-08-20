
//
//  ImmersiveView.swift
//  WaxBallTutorial
//
//  Created by 조민지 on 8/14/26.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    
    @State private var handTrackingManager = HandTrackingManager()
    
    var body: some View {
        RealityView { content in
            // Entity를 생성하고 공간에 추가
//            let ball = ModelEntity(
//                mesh: .generateSphere(radius: 0.08),
//                materials: [SimpleMaterial(
//                    color: .yellow,
//                    isMetallic: false
//                )]
//            )
            let stageNames = [
                "butterbar1",
                "butterbar2",
                "butterbar3",
                "butterbar4"
            ]

            do {
                var stages: [Entity] = []

                for name in stageNames {
                    let stage = try await Entity(named: name)
                    stages.append(stage)
                    content.add(stage)
                }

                handTrackingManager.waxBallController.connect(
                    to: stages
                )
            } catch {
                print("왁뿌볼 모델을 불러오지 못했습니다: \(error)")
            }
        }
        .task {
                await handTrackingManager.startTracking()
                }
    }
}

#Preview {
    ImmersiveView()
}
