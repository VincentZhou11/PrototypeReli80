//
//  DrawingTestingView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/6/22.
//

import SwiftUI

struct DrawingTestingSentenceView: View {
    
    @State var drawings: [Drawing] = []
    
    @State var canvasScale = 0.1
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings) {
                        drawing in
                        ScaledDrawingView(drawing: drawing, canvasScale: canvasScale)
                    }
                }
            
                HStack {
                    Text("Scale: \(canvasScale, specifier: "%.1f")")
                        .padding([.leading,.trailing])
                    Slider(value: $canvasScale, in: 0.1...1.0, step: 0.1)
                        .padding([.leading,.trailing])
                }
                
                NavigationLink {
                    DrawingView(onSubmit: onSubmit)
                } label: {
                    Label("Add", systemImage: "pencil.tip")
                }
            }
        }
    }
    
    func onSubmit(newDrawing: Drawing) {
        drawings.append(newDrawing)
    }
}

struct DrawingTestingSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingTestingSentenceView()
    }
}
