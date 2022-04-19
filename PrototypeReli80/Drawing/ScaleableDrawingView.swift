//
//  ScaleableDrawingView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import SwiftUI

struct ScaleableDrawingView: View {
    var drawing: Drawing
    var border: Bool = true
    
    var body: some View {
        GeometryReader {
            geometry in
            
            ZStack {
                if border {
                    Path { path in
                        path.addLines([CGPoint(x:0, y:0),
                                       CGPoint(x:0, y:geometry.size.height),
                                       CGPoint(x:geometry.size.width, y:geometry.size.height),
                                       CGPoint(x:geometry.size.width, y:0),
                                       CGPoint(x:0, y:0)])
                    }
                    .stroke(.black, lineWidth: 2.0 * geometry.size.height/350)
                }
                Path {
                    path in
                    
                    for stroke in drawing.strokes {
                        path.addLines(stroke.points.map {
                            point in
                            CGPoint(x: point.x*geometry.size.width/350, y: point.y*geometry.size.height/350)
                        })
                    }
                            
                }
                .stroke(drawing.color, lineWidth: drawing.lineWidth * geometry.size.height/350)
            }
        }
    }
}

struct ScaleableDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        ScaleableDrawingView(drawing: Drawing.example).frame(width: 150, height: 150)
    }
}
