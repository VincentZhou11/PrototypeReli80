//
//  GenericSentenceMenuView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import SwiftUI
import CoreData

struct GenericSentenceMenuView: View {
    @StateObject var vm: GenericSentenceMenuViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: GenericSentenceMenuViewModel(preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Logographic Sentences") {
                List {
                    ForEach(vm.logoSentences) {
                        logoSentence in
                        NavigationLink {
                            GenericSentenceEditorView(sentence: logoSentence, preview:preview)
                        } label: {
                            GenericSentenceMiniView(sentence: logoSentence)
                        }
                    }
                    .onDelete(perform: vm.deleteLogos)
                }
            }
            Section("Alphabet Sentences") {
                List {
                    ForEach(vm.alphaSentences) {
                        alphaSentence in
                        NavigationLink {
                            GenericSentenceEditorView(sentence: alphaSentence, preview: preview)
                        } label: {
                            GenericSentenceMiniView(sentence: alphaSentence, cols: 4)
                        }
                    }
                    .onDelete(perform: vm.deleteLogos)
                }
            }
        }
        .sheet(isPresented: $vm.sheetPresented) {
            GenericLanguageChooserView(vm: vm)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button{
                    vm.hardRefreshSentences()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                Button{
                    vm.addItem()
                } label: {
                    Label("Add Test Sentence", systemImage: "plus")
                }
                Button{
                    vm.sheetPresented = true
                } label: {
                    Label("Add Sentence", systemImage: "plus.square")
                }
                EditButton()
                
            }
        }
        .onAppear(perform:vm.refresh)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GenericSentenceMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenericSentenceMenuView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}


struct GenericSentenceMiniView<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: View {
    var sentence: SyncObject<GenericSentence, GenericSentenceDB>
    
    var columns: [GridItem]
    
    init(sentence: SyncObject<GenericSentence, GenericSentenceDB>) {
        self.sentence = sentence
        self.columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    }
    init(sentence: SyncObject<GenericSentence, GenericSentenceDB>, cols: Int) {
        self.sentence = sentence
        self.columns = []
        for _ in 0..<cols {
            self.columns.append(GridItem(.flexible()))
        }
    }
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            Text("Language: \(sentence.decoded.language.name)")
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(sentence.decoded.sentence) {
                    morpheme in
                    MorphemeView(morpheme: morpheme, border: false)
                        .scaledToFit()
                }
            }
        }
    }
}
struct GenericLanguageChooserView: View {
    @ObservedObject var vm: GenericSentenceMenuViewModel
    
    var body: some View {
        Form {
            Section("Logographic Languages") {
                List {
                    ForEach(vm.logoLanguages) {
                        logoLanguage in
                        Button {
                            vm.onLogoSubmit(choosenLanguage: logoLanguage.decoded)
                        } label: {
                            Text(logoLanguage.decoded.name)
                        }
                    }
                }
            }
            Section("Alphabet Languages") {
                List {
                    ForEach(vm.alphaLanguages) {
                        alphaLanguage in
                        Button {
                            vm.onAlphaSubmit(choosenLanguage: alphaLanguage.decoded)
                        } label: {
                            Text(alphaLanguage.decoded.name)
                        }
                    }
                }
            }
        }
    }
}

