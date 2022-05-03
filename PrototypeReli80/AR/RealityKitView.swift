//
//  RealityKitView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 5/2/22.
//

import SwiftUI

import ARKit
import RealityKit
import SwiftUI
import FocusEntity

//https://www.ralfebert.com/ios/realitykit-dice-tutorial/
struct RealityKitView<T: MorphemeSentence>: UIViewRepresentable {
    var sentence: T
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        // Start AR session
        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)

            // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)

            // Set debug options
//        #if DEBUG
//        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
//        #endif
        
        // Handle ARSession events via delegate
        context.coordinator.view = view
        session.delegate = context.coordinator
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )

        return view
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.tapHandler = onTap
        return coordinator
    }

    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var focusEntity: FocusEntity?
        var tapHandler: ((AnchorEntity, FocusEntity) -> ())?

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let view = self.view else { return }
            debugPrint("Anchors added to the scene: ", anchors)
            self.focusEntity = FocusEntity(on: view, style: .classic(color: .yellow))
        }
        
        @objc func handleTap() {
            guard let view = self.view, let focusEntity = self.focusEntity else { return }

            // Create a new anchor to add content to
            let anchor = AnchorEntity()
            view.scene.anchors.append(anchor)

            // Add a Box entity with a blue material
//            let box = MeshResource.generateBox(size: 0.5, cornerRadius: 0.05)
//            let material = SimpleMaterial(color: .blue, isMetallic: true)
//            let diceEntity = ModelEntity(mesh: box, materials: [material])
//            diceEntity.position = focusEntity.position
            
//            let text = MeshResource.generateText("String", extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail)
//            let textMaterial = SimpleMaterial(color: .blue, isMetallic: true)
//            let textEntity = ModelEntity(mesh: text, materials: [textMaterial])
//            textEntity.position = focusEntity.position
//            textEntity.scale = SIMD3<Float>(repeating: 0.03)
            
//            anchor.addChild(diceEntity)
//            anchor.addChild(textEntity)
            
//            let morpheme = Word.example
//            let child = drawMorpheme(morpheme: morpheme)
//            child.position = focusEntity.position
//
//            child.scale = SIMD3<Float>(repeating: 1)
            
            
            tapHandler?(anchor, focusEntity)
            
        }
    }
    
    func onTap(anchor: AnchorEntity, focusEntity: FocusEntity) {
        let morphemes = drawMorphemes(morphemes: sentence)
        morphemes.position = focusEntity.position
        morphemes.scale = SIMD3<Float>(repeating: 0.5)
        anchor.addChild(morphemes)
    }
    
    func drawMorphemes<T: MorphemeSentence>(morphemes: T) -> Entity {
        let parentEntity = Entity()
        for (i, morpheme) in morphemes.sentence.enumerated() {
            let morphemeEntity = drawMorpheme(morpheme: morpheme)
            morphemeEntity.position = parentEntity.position + SIMD3<Float>(x:Float(1*i)*0.20*4, y:0, z:0)

            parentEntity.addChild(morphemeEntity)
        }
        
        let text = MeshResource.generateText("\(morphemes.language.name)", extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail)
        let textMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [textMaterial])
//        textEntity.position = focusEntity.position
        textEntity.scale = SIMD3<Float>(repeating: 0.03)
        
        parentEntity.addChild(textEntity)
        
        return parentEntity
    }
    
    func drawMorpheme<T: Morpheme>(morpheme: T) -> Entity {
//        var childAnchors: [AnchorEntity] = []
        let parentEntity = Entity()
        for (i, drawing) in morpheme.morpheneDrawing.enumerated() {
//            print(i)
            let drawingEntity = Entity()
            drawingEntity.position = parentEntity.position + SIMD3<Float>(x:Float(1*i)*0.20, y:0, z:0)
            for stroke in drawing.strokes {
//                for i in 0..<stroke.points.count-1 {
//                    let point1 = stroke.points[i]
//                    let point2 = stroke.points[i+1]
//
////                    print("\(point1.x), \(point1.y); \(point2.x), \(point2.y)")
//
//                    drawingEntity.addChild(drawLine(position1: point2DTo3D(point: point1), position2: point2DTo3D(point: point2), reference: parentEntity))
//
//                }
                //Decimate
                let decimationFactor = 5
                
                for i in stride(from: 0, to: stroke.points.count-decimationFactor, by: decimationFactor) {
                    let point1 = stroke.points[i]
                    let point2 = stroke.points[i+decimationFactor]
                    
//                    print("\(point1.x), \(point1.y); \(point2.x), \(point2.y)")
                    
                    drawingEntity.addChild(drawLine(position1: point2DTo3D(point: point1), position2: point2DTo3D(point: point2), reference: parentEntity))
                }
            }
            
//            drawingEntity.addChild(textEntity)
            parentEntity.addChild(drawingEntity)
//            parentEntity.addChild(textEntity)
        }
        
        parentEntity.transform.rotation += simd_quatf(angle: Float.pi*0.5, axis: SIMD3<Float>(1,0,0))

        
        return parentEntity
    }
    
    func point2DTo3D(point: CGPoint, z: Float = 0) -> SIMD3<Float>{
        return SIMD3<Float>(x:Float(point.x)/350*0.25, y:Float(point.y)/350*0.25, z:z)
    }
    
    func drawLine(position1: SIMD3<Float>, position2: SIMD3<Float>, reference: Entity) -> Entity{
        let midPosition = SIMD3(x:(position1.x + position2.x) / 2,
                               y:(position1.y + position2.y) / 2,
                               z:(position1.z + position2.z) / 2)

        let anchor = Entity()
        anchor.position = midPosition
        anchor.look(at: position1, from: midPosition, relativeTo: nil)

        let meters = simd_distance(position1, position2)

        let lineMaterial = SimpleMaterial.init(color: .red,
                                              roughness: 1,
                                              isMetallic: false)

        let bottomLineMesh = MeshResource.generateBox(width:0.010,
                                                      height: 0.010,
                                                 depth: meters)

        let bottomLineEntity = ModelEntity(mesh: bottomLineMesh,
                                      materials: [lineMaterial])

//        bottomLineEntity.position = .init(0, 0.025, 0)
        anchor.addChild(bottomLineEntity)
        return anchor
    }

    func updateUIView(_ view: ARView, context: Context) {
    }
    
    func dismantleUIView(uiView: Self.UIViewType, coordinator: Self.Coordinator) {
    }
}

//struct RealityKitView_Previews: PreviewProvider {
//    static var previews: some View {
//        RealityKitView()
//    }
//}
