//
//  AlphaLanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//
import SwiftUI

struct AlphaLanguageEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: AlphaLanguageEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: AlphaLanguageEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: AlphaLanguageEditorViewModel(alphaLanguage: alphaLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Language Name", text: $vm.alphaLanguage.decoded.name)
            }
            
            Section("Words") {
                Button{
                    vm.addWord()
                } label: {
                    Label("Add Word", systemImage: "plus")
                }
                List {
                    ForEachWithIndex(vm.alphaLanguage.decoded.morphemes) {
                        idx, word in
                        NavigationLink {
                            WordEditorView(idx: idx, alphaLanguage: vm.alphaLanguage)
                        } label: {
                            Text("\(word.meaning)")
                        }
                    }.onDelete(perform: vm.deleteWords)
                }
            }
            Section("Letters") {
                Button{
                    vm.addLetter()
                } label: {
                    Label("Add Letter", systemImage: "plus")
                }
                List {
                    ForEachWithIndex(vm.alphaLanguage.decoded.letters) {
                        idx, letter in
                        NavigationLink {
                            LetterEditorView(idx: idx, alphaLanguage: vm.alphaLanguage, preview: preview)

                        } label: {
                            Text("\(letter.pronounciation)")
                        }
                    }.onDelete(perform: vm.deleteLetters)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                Button {
                    vm.save()
//                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.alphaLanguage.synced)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear(perform: vm.refresh)
        .onReceive(vm.alphaLanguage.publisher) { output in
            vm.alphaLanguage = output
        }
    }
}

struct AlphaLanguageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlphaLanguageEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
