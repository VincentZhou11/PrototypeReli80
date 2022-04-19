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
            Section("Logographic Languages") {
                List {
                    ForEach(vm.logoSentences) {
                        logoSentence in
                        NavigationLink {
                            LogographicSentenceMiniView(sentence: logoSentence.decoded.sentence)
                        } label: {
                            Text(logoSentence.decoded.id.uuidString)
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button{
                    vm.refreshSentences()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                Button{
                    vm.addItem()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
                EditButton()
            }
        }
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
    
    var sentence: [Logogram]
    
    var body: some View {
        Text("Test")
    }
}
