//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageMenuView: View {
    @StateObject var vm: LanguageMenuViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LanguageMenuViewModel(preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Logographic Languages") {
                List {
                    ForEach(vm.logoLanguages) {
                        logoLanguage in
                        NavigationLink {
                            LanguageEditorView(logoLanguage: logoLanguage, preview: preview)
                        } label: {
                            Text(logoLanguage.decoded.name)
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button{
                    vm.refresh()
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

struct LanguageMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LanguageMenuView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
