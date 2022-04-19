//
//  ScaledDrawingView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/9/22.
//

import SwiftUI

struct ScaledDrawingView: View {
    
    var drawing: Drawing
    var canvasScale = 1.0
    
    var body: some View {
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
    }
}

struct ScaledDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        ScaledDrawingView(drawing: Drawing.example)
    }
}
