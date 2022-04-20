//
//  DrawingPadView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/6/22.
//

import SwiftUI

struct DrawingView: View {
//    @State var currentDrawing: Drawing = Drawing()
//    @State var drawings: [Drawing] = []
//    @State var color: Color = Color.black
//    @State var lineWidth: CGFloat = 3.0
//
//    @State var colorPickerShown = false
    @Environment(\.dismiss) var dismiss

    @StateObject var vm: DrawingViewModel
    
    init() {
        _vm = StateObject(wrappedValue: DrawingViewModel())
    }
    init(drawing: Drawing) {
        _vm = StateObject(wrappedValue: DrawingViewModel(drawing: drawing))
    }
    init(onSubmit: @escaping((Drawing) -> ())) {
        _vm = StateObject(wrappedValue: DrawingViewModel(onSubmit: onSubmit))
    }
    init(drawing: Drawing, onSubmit: @escaping((Drawing) -> ())) {
        _vm = StateObject(wrappedValue: DrawingViewModel(drawing: drawing, onSubmit: onSubmit))
    }
    
    var body: some View {
        VStack{
            DrawingPadView(vm: vm)
            DrawingControlsView(vm: vm)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button {
//                    vm.delete()
//                    dismiss()
//                } label: {
//                    Image(systemName: "trash").foregroundColor(.red)
//                }
                Button {
                    vm.submit()
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrawingView()
        }
    }
}

struct DrawingPadView: View {
//    @Binding var currentDrawing: Drawing
//    @Binding var drawings: [Drawing]
//    @Binding var color: Color
//    @Binding var lineWidth: CGFloat
    
    @ObservedObject var vm: DrawingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Path { path in
                    path.addLines([CGPoint(x:0, y:0),
                                   CGPoint(x:0, y:geometry.size.height),
                                   CGPoint(x:geometry.size.width, y:geometry.size.height),
                                   CGPoint(x:geometry.size.width, y:0),
                                   CGPoint(x:0, y:0)])
                }
                .stroke(.black, lineWidth: 2.0)

                Path { path in
                    
                    
                    
                    for stroke in self.vm.strokes {
                        path.move(to: stroke.points.first!)
                        path.addLines(stroke.points)
                    }
                    path.addLines(self.vm.currentStroke.points)
                }
                .stroke(self.vm.color, lineWidth: self.vm.lineWidth)
            }
            
            // Bruh absolute god tier fix
            // Apparrently having a clear background removes the cotent shape
            // https://stackoverflow.com/questions/58696455/swiftui-ontapgesture-on-color-clear-background-behaves-differently-to-color-blue
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.1)
                .onChanged({ (value) in
                    print(value)
                    let currentPoint = value.location
                    if currentPoint.y >= 0 && currentPoint.y < geometry.size.height && currentPoint.x >= 0 && currentPoint.x < geometry.size.width
                    {
                        self.vm.currentStroke.points.append(currentPoint)
                    }
                })
                .onEnded({ (value) in
                    self.vm.strokes.append(self.vm.currentStroke)
                    self.vm.currentStroke = Stroke(points: [])
                })
            )
        }
        .frame(width: 350, height: 350)
//        .frame(maxHeight: .infinity)
    }
}

struct DrawingControlsView: View {
//    @Binding var currentDrawing: Drawing
//    @Binding var drawings: [Drawing]
//    @Binding var color: Color
//    @Binding var lineWidth: CGFloat
    
//    @Binding var colorPickerShown: Bool
    
    @ObservedObject var vm: DrawingViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 40) {
                ColorPicker("", selection: $vm.color).frame(width: 20)
                Button("Undo") {
                    if self.vm.strokes.count > 0 {
                        self.vm.strokes.removeLast()
                    }
                }
                Button("Clear") {
                    self.vm.strokes = [Stroke]()
                }
            }
            HStack {
                Text("Pencil width")
                    .padding([.leading,.trailing])
                Slider(value: $vm.lineWidth, in: 1.0...15.0, step: 1.0)
                    .padding([.leading,.trailing])
            }
        }
    }
}
