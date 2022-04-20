//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: LanguageEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LanguageEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: LanguageEditorViewModel(logoLanguage: logoLanguage, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Language Name", text: $vm.logoLanguage.decoded.name)
            }
            
            Section("Logograms") {
                List {
                    ForEachWithIndex(vm.logoLanguage.decoded.logograms) {
                        idx, logogram in
                        NavigationLink {
                            LogogramEditorView(idx: idx, logoLanguage: vm.logoLanguage, preview: preview)
                        } label: {
                            Text("\(logogram.meaning)")
                        }
                    }.onDelete(perform: vm.deleteItems)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button{
                    vm.addItem()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
                EditButton()
                Button {
                    vm.save()
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: vm.refresh)
    }
}

struct LanguageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LanguageEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
