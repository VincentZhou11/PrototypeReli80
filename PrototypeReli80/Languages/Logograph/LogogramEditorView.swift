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
        let logogram = vm.logoLanguage.decoded.morphemes[vm.idx]
        
        Form {
            Section("Drawing") {
                ScaleableDrawingView(drawing: logogram.drawing).scaledToFit()
                NavigationLink {
                    DrawingView(drawing: logogram.drawing, onSubmit: vm.onSubmit)
                } label: {
                    Label("Edit drawing", systemImage: "paintbrush.pointed")
                }
            }
            Section("Properties") {
                HStack {
                    Text("Meaning")
                    Divider()
                    TextField("Meaning", text: $vm.logoLanguage.decoded.morphemes[vm.idx].meaning)
                }
                HStack {
                    Text("Pronunciation")
                    Divider()
                    TextField("Pronunciation", text: $vm.logoLanguage.decoded.morphemes[vm.idx].pronunciation)
                        .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button {
                                vm.phonemeSheet = true
                            } label: {
                                Text("IPA")
                            }
                        }
                    }
                }.sheet(isPresented: $vm.phonemeSheet) {
                    PhonemeChooserView(onSubmit: vm.phonemeOnSubmit)
                }
            }
//            Section("Semantic Class") {
//                
//            }
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
//                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.logoLanguage.synced)
            }
        }
        .navigationTitle("Logogram Editor")
        .onReceive(vm.logoLanguage.publisher) { output in
            vm.logoLanguage = output
        }
    }
}

struct LogogramEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogogramEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
        }
    }
}
