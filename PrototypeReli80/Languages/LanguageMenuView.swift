//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageMenuView: View {
    @StateObject var vm: LanguageMenuViewModel
    
    init(preview: Bool = false) {
        _vm = StateObject<LanguageMenuViewModel>(wrappedValue: LanguageMenuViewModel(preview: preview))
    }
    
    var body: some View {
        Form {
            Section("Logographic Languages") {
                List {
                    ForEach(vm.logoLanguages) {
                        logoLanguage in
                        NavigationLink {
                            
                        } label: {
                            Text(logoLanguage.decoded.name)
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
