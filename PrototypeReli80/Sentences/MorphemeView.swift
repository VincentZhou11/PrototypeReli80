//
//  MorphemeView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/21/22.
//

import SwiftUI

struct MorphemeView<T: Morpheme>: View {
    var morpheme: T
    var border: Bool
    var height: Double
    
//    init(morpheme: T, border: Bool) {
//        self.morpheme = morpheme
//        self.border = border
//    }
    var body: some View {
        HStack(spacing: 0) {
            ForEach(morpheme.morpheneDrawing) {
                drawing in
                
                ScaleableDrawingView(drawing: drawing, border: border)
                    .scaledToFit()
            }
        }.frame(height: height)
    }
}

struct MorphemeView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
        ]
        let morphemes: [Word] = [.example, .example, .example, .example,.example]
        let morphemes2: [Logogram] = [.example, .example, .example, .example,.example]
        LazyVGrid(columns: columns, spacing:5) {
                ForEach(morphemes) {
                    morpheme in
                    MorphemeView(morpheme: morpheme, border: false, height: 20)
                        .scaledToFit()
                }
//            Spacer()
        }
//        MorphemeView(morpheme: Word.example, border: false)
    }
}
