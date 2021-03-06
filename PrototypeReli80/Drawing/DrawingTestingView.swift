//
//  DrawingTestingView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/6/22.
//

import SwiftUI

struct DrawingTestingView: View {
    
    @State var drawing: Drawing?
    
    @State var canvasScale = 1.0
    
    @State var json = "bro"
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                        GeometryReader {
                            geometry in
                            
                            ZStack {
                                Path { path in
                                    path.addLines([CGPoint(x:0, y:0),
                                                   CGPoint(x:0, y:geometry.size.height),
                                                   CGPoint(x:geometry.size.width, y:geometry.size.height),
                                                   CGPoint(x:geometry.size.width, y:0),
                                                   CGPoint(x:0, y:0)])
                                }
                                .stroke(.black, lineWidth: 2.0)
                                if let drawing = drawing {
                                    Path {
                                        path in
                                        
                                        for stroke in drawing.strokes {
                                            path.addLines(stroke.points.map {
                                                point in
                                                CGPoint(x: point.x*canvasScale, y: point.y*canvasScale)
                                            })
                                        }
                                                
                                    }
                                    .stroke(drawing.color, lineWidth: drawing.lineWidth * canvasScale)
                                }
                            }
                            
                        }
                        .frame(width:350*canvasScale, height: 350*canvasScale)
                    
                    HStack {
                        Text("Scale: \(canvasScale, specifier: "%.1f")")
                            .padding([.leading,.trailing])
                        Slider(value: $canvasScale, in: 0.1...1.0, step: 0.1)
                            .padding([.leading,.trailing])
                    }
                    
                    NavigationLink {
                        DrawingView(onSubmit: onSubmit)
                    } label: {
                        Label("Test", systemImage: "cogs")
                    }
                }
                TextEditor(text: $json).background(.secondary).cornerRadius(5).padding()
            }
        }
        .navigationBarHidden(true)
    }
    
    func onSubmit(newDrawing: Drawing) {
        drawing = newDrawing
        do {
            json = String(decoding: try JSONEncoder().encode(newDrawing.strokes), as: UTF8.self)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

struct DrawingTestingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingTestingView()
    }
}
