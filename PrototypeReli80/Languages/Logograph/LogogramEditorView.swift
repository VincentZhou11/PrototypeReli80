//
//  LogogramEditor.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import SwiftUI

struct LogogramEditorView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: LogogramEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogogramEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(idx: Int, logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogogramEditorViewModel(idx: idx, logoLanguage: logoLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        let logogram = vm.logoLanguage.decoded.logograms[vm.idx]
        
        Form {
            Section("Drawing") {
                ScaleableDrawingView(drawing: logogram.drawing).scaledToFit()
                NavigationLink {
                    DrawingView(drawing: logogram.drawing, onSubmit: vm.onSubmit)
                } label: {
                    Label("Edit drawing", systemImage: "paintbrush.pointed")
                }
            }
            Section("Meaning") {
                TextField("Meaning", text: $vm.logoLanguage.decoded.logograms[vm.idx].meaning)
            }
            Section("Semantic Class") {
                
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Button {
//                    vm.delete()
//                    dismiss()
//                } label: {
//                    Image(systemName: "trash").foregroundColor(.red)
//                }
                Button {
                    vm.save()
                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.logoLanguage.synced)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LogogramEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogogramEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
