import SwiftUI

@main
struct GraspApp: App {
    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
        }
        
        ImmersiveSpace(id: "GraspSpace") {
            ImmersiveView()
        }
    }
}
