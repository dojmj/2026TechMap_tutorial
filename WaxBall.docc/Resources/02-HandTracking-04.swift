//
//  02-HandTracking-04.swift
//  
//
//  Created by Kimseoyeon on 8/18/26.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    
    private let handTrackingManager = HandTrackingManager()
    
    var body: some View {
        RealityView { content in
            
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
