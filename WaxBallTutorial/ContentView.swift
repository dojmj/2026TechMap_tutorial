//
//  ContentView.swift
//  WaxBallTutorial
//
//  Created by 조민지 on 8/14/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace)
    private var openImmersiveSpace

    @Environment(\.dismissWindow)
    private var dismissWindow
    
    var body: some View {
        Button("몰입 공간 열기") {
            Task {
                let result = await openImmersiveSpace(
                    id: "WaxBallSpace"
                )

                if result == .opened {
                    dismissWindow(id: "MainWindow")
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
