//
//  LetterEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import SwiftUI

struct LetterEditorView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: LetterEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LetterEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(idx: Int, alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: LetterEditorViewModel(idx: idx, alphaLanguage: alphaLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        let letter = vm.alphaLanguage.decoded.letters[vm.idx]
        
        Form {
            Section("Drawing") {
                ScaleableDrawingView(drawing: letter.drawing).scaledToFit()
                NavigationLink {
                    DrawingView(drawing: letter.drawing, onSubmit: vm.onSubmit)
                } label: {
                    Label("Edit drawing", systemImage: "paintbrush.pointed")
                }
            }
            Section("Properties") {
                HStack {
                    Text("Phoneme")
                    Divider()
                    TextField("Phoneme", text: $vm.alphaLanguage.decoded.letters[vm.idx].pronounciation)
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
                    PhonemeChooserView()
                }
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
//                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.alphaLanguage.synced)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(vm.alphaLanguage.publisher) { output in
            vm.alphaLanguage = output
        }
    }
}

struct LetterEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LetterEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
