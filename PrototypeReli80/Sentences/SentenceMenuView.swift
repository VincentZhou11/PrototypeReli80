//
//  SentenceMenuView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import SwiftUI

struct SentenceMenuView: View {
    @StateObject var vm: SentenceMenuViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: SentenceMenuViewModel(preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Logographic Sentences") {
                List {
                    ForEach(vm.logoSentences) {
                        logoSentence in
                        NavigationLink {
                            SentenceEditorView(sentence: logoSentence, preview: preview)
                        } label: {
                            LogographicSentenceMiniView(sentence: logoSentence)
                        }
//                        LogographicSentenceMiniView(sentence: logoSentence.decoded.sentence)
                    }
                    .onDelete(perform: vm.deleteItems)
                }
            }
        }
        .sheet(isPresented: $vm.sheetPresented) {
            LanguageChooserView(logoLanguages: vm.logoLanguages, onSubmit: vm.onSubmit)
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

struct SentenceMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SentenceMenuView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

struct LogographicSentenceMiniView: View {
    var sentence: SyncObject<LogographicSentence, LogographicSentenceDB>
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        VStack(alignment: .leading) {
            Text("Language: \(sentence.decoded.language.name)")
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(sentence.decoded.sentence) {
                    logogram in
                    ScaleableDrawingView(drawing: logogram.drawing, border: false).scaledToFit()
                }
            }
        }
    }
}
struct LanguageChooserView: View {
    var logoLanguages: [SyncObject<LogographicLanguage, LogographicLanguageDB>] = []
    var onSubmit: (LogographicLanguage) -> ()
    
    var body: some View {
        Form {
            Section("Logographic languages") {
                List {
                    ForEach(logoLanguages) {
                        logoLanguage in
                        Button {
                            onSubmit(logoLanguage.decoded)
                        } label: {
                            Text(logoLanguage.decoded.name)
                        }
                    }
                }
            }
        }
    }
}
