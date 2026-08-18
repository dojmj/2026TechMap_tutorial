//
//  WaxBallTutorialApp.swift
//  WaxBallTutorial
//
//  Created by 조민지 on 8/14/26.
//

import SwiftUI

@main
struct WaxBallTutorialApp: App {
    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
        }
        
        ImmersiveSpace(id: "WaxBallSpace") {
            ImmersiveView()
        }
    }
}
