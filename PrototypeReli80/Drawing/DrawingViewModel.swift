//
//  DrawingViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/6/22.
//

import Foundation
import SwiftUI

public class DrawingViewModel: ObservableObject {
    @Published var currentStroke: Stroke = Stroke(points: [])
    @Published var strokes: [Stroke] = []
    @Published var color: Color = Color.black
    @Published var lineWidth: CGFloat = 3.0
         
    var submitDelegate: ((Drawing) -> ())?
    
    init() {
        
    }
    
    init(drawing: Drawing) {
        strokes = drawing.strokes
        color = drawing.color
        lineWidth = drawing.lineWidth
    }
    
    init(onSubmit: ((Drawing) -> ())?) {
        submitDelegate = onSubmit
    }
    
    init(drawing: Drawing, onSubmit: ((Drawing) -> ())?) {
        strokes = drawing.strokes
        color = drawing.color
        lineWidth = drawing.lineWidth
        submitDelegate = onSubmit
    }
    
    func submit() {
        if let submitDelegate = submitDelegate {
            submitDelegate(Drawing(strokes: strokes, color: color, lineWidth: lineWidth))
        }
        else {
            print("No delegate registered")
        }
    }
    
    func delete() {
    }
}
