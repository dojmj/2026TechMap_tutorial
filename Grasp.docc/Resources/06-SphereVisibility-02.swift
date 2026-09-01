RealityView { content in
    let sphere = ModelEntity(
        mesh: .generateSphere(radius: 0.12),
        materials: [
            SimpleMaterial(
                color: .cyan,
                isMetallic: false
            )
        ]
    )

    sphere.name = "GraspSphere"
    sphere.position = [0, 1.2, -1.2]

    content.add(sphere)
    handTrackingManager.graspController.connect(to: sphere)
}
