//
//  GenericSentenceEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import SwiftUI
import CoreData

struct GenericSentenceEditorView<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: View{
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: GenericSentenceEditorViewModel<GenericSentence, GenericSentenceDB>
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: GenericSentenceEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(sentence: SyncObject<GenericSentence, GenericSentenceDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: GenericSentenceEditorViewModel(sentence: sentence, preview: preview))
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
            Form {
                Section("Language") {
                    Text("Type: \(String(describing: type(of: vm.sentence.decoded.language)))")
                    Picker("Language", selection: $vm.languageIdx) {
                        Text("Cached: \(vm.sentence.decoded.language.name)")
                            .tag(-1)
                        ForEachWithIndex(vm.languages) { idx, language in
                            Text(language.name)
                                .tag(idx)
                        }
                    }
                    Button {
                        
                    } label: {
                        Label("Refresh Language", systemImage: "arrow.clockwise")
                    }
                    Button {
                        
                    } label: {
                        Label("Set Language", systemImage: "wrench")
                    }
                }
            }.tabItem {
                Label("Configure Sentence", systemImage: "gear")
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Language: \(vm.sentence.decoded.language.name)")
                LazyVGrid(columns: columns) {
                    ForEachWithIndex(vm.sentence.decoded.sentence) {
                        idx, morpheme in
                        Button {
                            vm.editSheet = true
                        } label: {
                            MorphemeView(morpheme: morpheme, border: false).scaledToFit().padding(2).overlay(alignment:.bottom) {
                                Rectangle().frame(height: 1)
                            }
                        }
                        .scaledToFit()
                        .sheet(isPresented: $vm.editSheet) {
                            GenericSheetEditView(viewContext: vm.viewContext, sentence: $vm.sentence, choosenIdx: idx, binding: $vm.editSheet)
                        }
                    }
                    
                    Button {
                        vm.newSheet = true
                    } label : {
                        Image(systemName: "plus.square").font(.title)
                    }
                    .sheet(isPresented: $vm.newSheet) {
                        GenericSheetNewView(viewContext: vm.viewContext, sentence: $vm.sentence, binding: $vm.newSheet)
                    }
                }
                Spacer()
            }.tabItem {
                Label("Assemble Sentence", systemImage: "doc.zipper")
            }.padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.save()
//                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.sentence.synced)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GenericSentenceEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenericSentenceEditorView<AlphabetSentence, AlphabetSentenceDB>(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
class GenericSheetViewModel<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: ObservableObject {
    @Published var viewContext: NSManagedObjectContext
    @Binding var sentence: SyncObject<GenericSentence, GenericSentenceDB>
    @Binding var binding: Bool
    
    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<GenericSentence, GenericSentenceDB>>, binding: Binding<Bool>) {
        self.viewContext = viewContext
        self._sentence = sentence
        self._binding = binding
    }
}
struct GenericSheetEditView<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: View {
    @StateObject var vm: GenericSheetViewModel<GenericSentence, GenericSentenceDB>
    
    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<GenericSentence, GenericSentenceDB>>, choosenIdx: Int, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: GenericSheetViewModel(viewContext: viewContext, sentence: sentence, binding: binding))
        self.choosenIdx = choosenIdx
    }
    
    var choosenIdx: Int
    
    var body: some View {
        Form {
            Section("Morphemes") {
                List {
                    ForEachWithIndex(vm.sentence.decoded.language.morphemes) {
                        idx, morpheme in
                        Button {
                            vm.sentence.decoded.sentence[idx] = morpheme.copy() as! GenericSentence.MorphemeType
//                            vm.sentence.saveManagedObject()
                            vm.binding = false
                        } label: {
                            Text("\(morpheme.morphemeMeaning)")
                        }
                    }
                }
            }
            Section() {
                Button {
                    vm.sentence.decoded.sentence.remove(at: choosenIdx)
//                    vm.sentence.saveManagedObject()
                    vm.binding = false
                } label: {
                    Text("Delete").foregroundColor(.red)
                }
            }
        }
    }
}
struct GenericSheetNewView<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: View {
    @StateObject var vm: GenericSheetViewModel<GenericSentence, GenericSentenceDB>

    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<GenericSentence, GenericSentenceDB>>, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: GenericSheetViewModel(viewContext: viewContext, sentence: sentence, binding: binding))
    }
        
    var body: some View {
        Form {
            Section("Morphemes") {
                List {
                    ForEachWithIndex(vm.sentence.decoded.language.morphemes) {
                        idx, morpheme in
                        Button {
                            vm.sentence.decoded.sentence.append(morpheme.copy() as! GenericSentence.MorphemeType)
//                            vm.sentence.saveManagedObject()
                            vm.binding = false
                        } label: {
                            Text("\(morpheme.morphemeMeaning)")
                        }
                    }
                }
            }
        }
    }
}

