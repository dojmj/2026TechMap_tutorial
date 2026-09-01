import Foundation
import ARKit

@MainActor
final class HandTrackingManager {
    
    let session = ARKitSession()
    let handTracking = HandTrackingProvider()
    
    func startTracking() async {
        do {
            try await session.run([
                handTracking
            ])
            
            print("✅ Hand tracking started")
            
        } catch {
            print("❌ Hand tracking failed: \(error)")
        }
    }
}
