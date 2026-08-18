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
            if let butterbar = try? await Entity(
                named: "butterbar1"
            ) {
                content.add(butterbar)
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
