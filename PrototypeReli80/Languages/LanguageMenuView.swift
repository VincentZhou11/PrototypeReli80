//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: JSONLogographicLanguageDB.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JSONLogographicLanguageDB.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<JSONLogographicLanguageDB>
        
    @StateObject var vm: LanguageMenuViewModel
    
    init(preview: Bool = false) {
        _vm = StateObject<LanguageMenuViewModel>(wrappedValue: LanguageMenuViewModel(preview: preview))
    }
    
    var body: some View {
        Form {
            Section("Logographic Languages") {
                List {
                    ForEach(vm.decodedLogoLanguages) {
                        logographicLanguage in
                        NavigationLink {
                            
                        } label: {
                            Text(logographicLanguage.name)
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button{
                    vm.addItem()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguageMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LanguageMenuView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
