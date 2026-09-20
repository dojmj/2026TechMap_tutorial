import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace)
    private var openImmersiveSpace

    @Environment(\.dismissWindow)
    private var dismissWindow
    
    var body: some View {
        Button("몰입 공간 열기") {
            Task {
                let result = await openImmersiveSpace(
                    id: "GraspSpace"
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
