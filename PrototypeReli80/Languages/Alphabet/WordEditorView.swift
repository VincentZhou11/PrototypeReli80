//
//  WordEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import SwiftUI

import SwiftUI
import CoreData

struct WordEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: WordEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: WordEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(idx:Int, alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: WordEditorViewModel(idx: idx, alphaLanguage: alphaLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
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

        TabView {
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEachWithIndex(vm.alphaLanguage.decoded.morphemes[vm.idx].spelling) {
                    idx, letter in
                    Button {
                        vm.editSheet = true
                        vm.wordIdx = idx
                    } label: {
                        ScaleableDrawingView(drawing: letter.drawing, border: false).scaledToFit().padding(2).overlay(alignment:.bottom) {
                            Rectangle().frame(height: 1)
                        }
                    }
                    
                }
                .sheet(isPresented: $vm.editSheet) {
                    WordSheetEditView(wordIdx: vm.idx, choosenIdx: vm.wordIdx, alphaLanguage: $vm.alphaLanguage, binding: $vm.editSheet)
                }
                
                Button {
                    vm.newSheet = true
                } label : {
//                    Rectangle().foregroundColor(.clear).scaledToFit().border(.blue, width: 2.0).overlay(alignment:.center) {
//                        Image(systemName: "plus").font(.largeTitle).foregroundColor(.blue)
//                    }
                    Image(systemName: "plus.square").font(Font.title.weight(.light))
                }
//                .buttonStyle(.plain)
                .sheet(isPresented: $vm.newSheet) {
                    WordSheetNewView(wordIdx: vm.idx, alphaLanguage: $vm.alphaLanguage, binding: $vm.newSheet)
                }
            }.tabItem {
                Label("Assemble Letters", systemImage: "doc.zipper")
            }
            .padding()
            Form {
                Section("Properties") {
                    HStack {
                        Text("Meaning")
                        Divider()
                        TextField("Meaning", text: $vm.alphaLanguage.decoded.morphemes[vm.idx].meaning)
                    }
                    HStack {
                        Text("Pronunciation")
                        Divider()
//                        HStack {
//                            ForEach(vm.alphaLanguage.decoded.morphemes[vm.idx]) {
//                                letter in
//                                Text(letter.pronunciation)
//                            }
//                        }
                        Text(vm.alphaLanguage.decoded.morphemes[vm.idx].morphemePronunciation)
                    }
                }
                Section("Preview") {
                    MorphemeView(morpheme: vm.alphaLanguage.decoded.morphemes[vm.idx], border: false).scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                        Rectangle().frame(height: 1)
                    }
                }
            }.tabItem {
                Label("Configure Word", systemImage: "gear")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.save()
//                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.alphaLanguage.synced)
            }
        }
        .navigationBarTitle("Word Editor")
        .onReceive(vm.alphaLanguage.publisher) { output in
            vm.alphaLanguage = output
        }
    }
}

struct WordEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WordEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
        }
    }
}
class WordSheetViewModel: ObservableObject {
    @Published var wordIdx: Int
    @Binding var alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>
    @Binding var binding: Bool
    
    init (wordIdx: Int, alphaLanguage: Binding<SyncObject<AlphabetLanguage, AlphabetLanguageDB>>, binding: Binding<Bool>) {
        self.wordIdx = wordIdx
        self._alphaLanguage = alphaLanguage
        self._binding = binding
    }
}
struct WordSheetEditView: View {
    @StateObject var vm: WordSheetViewModel
    
    init (wordIdx: Int, choosenIdx: Int, alphaLanguage: Binding<SyncObject<AlphabetLanguage, AlphabetLanguageDB>>, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: WordSheetViewModel(wordIdx: wordIdx, alphaLanguage: alphaLanguage, binding: binding))
        self.choosenIdx = choosenIdx
    }
    
    var choosenIdx: Int
    
    var body: some View {
        Form {
            Section() {
                ScaleableDrawingView(drawing: vm.alphaLanguage.decoded.morphemes[vm.wordIdx].spelling[choosenIdx].drawing, border: false).scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                    Rectangle().frame(height: 1)
                }
            }
            Section("Properties") {
                HStack {
                    Text("Pronunciation")
                    Divider()
                    Text("\(vm.alphaLanguage.decoded.morphemes[vm.wordIdx].spelling[choosenIdx].pronunciation)")
                }
            }
            Section("Replace With") {
                List {
                    ForEach(vm.alphaLanguage.decoded.letters) {
                        letter in
                        Button {
                            withAnimation {
                                vm.alphaLanguage.decoded.morphemes[vm.wordIdx].spelling[choosenIdx] = letter.copy()
    //                            vm.alphaLanguage.saveManagedObject()
                                vm.binding = false
                            }
                        } label: {
                            HStack {
                                Text("\(letter.pronunciation)")
                                Divider()
                                ScaleableDrawingView(drawing: letter.drawing, border: false).scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                                    Rectangle().frame(height: 1)
                                }.frame(height:20)
                            }
                        }
                    }
                }
            }
            Section() {
                Button {
                    withAnimation {
                        vm.alphaLanguage.decoded.morphemes[vm.wordIdx].spelling.remove(at: choosenIdx)
    //                    vm.alphaLanguage.saveManagedObject()
                        vm.binding = false
                    }
                } label: {
                    Text("Delete").foregroundColor(.red)
                }
            }
        }
    }
}
struct WordSheetNewView: View {
    @StateObject var vm: WordSheetViewModel
    
    init (wordIdx: Int, alphaLanguage: Binding<SyncObject<AlphabetLanguage, AlphabetLanguageDB>>, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: WordSheetViewModel(wordIdx: wordIdx, alphaLanguage: alphaLanguage, binding: binding))
    }
        
    var body: some View {
        Form {
            Section("Letters") {
                List {
                    ForEach(vm.alphaLanguage.decoded.letters) {
                        letter in
                        Button {
                            withAnimation {
                                vm.alphaLanguage.decoded.morphemes[vm.wordIdx].spelling.append(letter.copy())
    //                            vm.alphaLanguage.saveManagedObject()
                                vm.binding = false
                            }
                        } label: {
                            HStack {
                                Text("\(letter.pronunciation)")
                                Divider()
                                ScaleableDrawingView(drawing: letter.drawing, border: false).scaledToFit().padding(.bottom, 1).overlay(alignment: .bottom) {
                                    Rectangle().frame(height: 1)
                                }.frame(height:20)
                            }
                        }
                    }
                }
            }
        }
    }
}

