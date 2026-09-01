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

            await processHandUpdates()

        } catch {
            print("Hand tracking failed: \(error)")
        }
    }

    private func processHandUpdates() async {

        for await update in handTracking.anchorUpdates {

            let handAnchor = update.anchor

            guard handAnchor.isTracked else {
                continue
            }

            guard let skeleton = handAnchor.handSkeleton else {
                continue
            }
        }
    }
}
