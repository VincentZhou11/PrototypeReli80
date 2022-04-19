//
//  LogogramEditor.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import SwiftUI

struct LogogramEditor: View {
    @StateObject var vm: LogogramEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogogramEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(idx: Int, logoLanguage: DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogogramEditorViewModel(idx: idx, logoLanguage: logoLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Drawing") {
                ScaleableDrawingView(drawing: vm.logogram.drawing).scaledToFit()
                NavigationLink {
                    DrawingView(drawing: vm.logogram.drawing, onSubmit: vm.onSubmit)
                } label: {
                    Label("Edit drawing", systemImage: "paintbrush.pointed")
                }
            }
            Section("Meaning") {
                Text(vm.logogram.meaning)
                TextField("Meaning", text: $vm.logogram.meaning)
            }
            Section("Semantic Class") {
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: vm.refresh)
    }
}

struct LogogramEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogogramEditor(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
