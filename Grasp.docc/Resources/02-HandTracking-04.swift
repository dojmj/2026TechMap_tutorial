import SwiftUI
import RealityKit

struct ImmersiveView: View {
    
    @State private var handTrackingManager = HandTrackingManager()
    
    var body: some View {
        RealityView { content in
            // RealityKit 콘텐츠는 뒤 단계에서 추가합니다.
        }
        .task {
            await handTrackingManager.startTracking()
        }
    }
}
