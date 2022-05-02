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
            GroupBox {
                Text("Words: \(vm.alphaLanguage.decoded.morphemes.count)")
                Text("Letters: \(vm.alphaLanguage.decoded.letters.count)")
            } label: {
                HStack {
                    Image(systemName: "sum")
                    Text("Stats")
                }
            }.groupBoxStyle(NoMarginGroupBox())
            
            Section("Properties") {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Script Name", text: $vm.alphaLanguage.decoded.name)
                }
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
                            HStack {
                                Text("\(word.meaning): ")
                                MorphemeView(morpheme: word, border: false)
                                    .scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                                        Rectangle().frame(height: 1)
                                    }.frame(height:20)
                            }
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
                            HStack {
                                Text("\(letter.pronunciation): ")
                                ScaleableDrawingView(drawing: letter.drawing, border: false).scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                                    Rectangle().frame(height: 1)
                                }.frame(height:20)
                            }
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
        .navigationTitle("Script Editor")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear(perform: vm.refresh)
        .onReceive(vm.alphaLanguage.publisher) { output in
            vm.alphaLanguage = output
        }
    }
}

struct AlphaLanguageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlphaLanguageEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
        }
    }
}
