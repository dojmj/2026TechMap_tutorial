import Foundation
import ARKit

@MainActor
final class HandTrackingManager {
    
    let session = ARKitSession()
    let handTracking = HandTrackingProvider()
}
