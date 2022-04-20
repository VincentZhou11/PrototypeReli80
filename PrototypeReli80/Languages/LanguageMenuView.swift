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
                    Button{
                        vm.addLogo()
                    } label: {
                        Label("Add Logographic Language", systemImage: "plus")
                    }
                    ForEach(vm.logoLanguages) {
                        logoLanguage in
                        NavigationLink {
                            LogoLanguageEditorView(logoLanguage: logoLanguage, preview: preview)
                        } label: {
                            Text(logoLanguage.decoded.name)
                        }
                    }
                    .onDelete(perform: vm.deleteLogos)
                }
            }
            Section("Alphabet Languages") {
                List {
                    Button{
                        vm.addAlpha()
                    } label: {
                        Label("Add Alphabet Language", systemImage: "plus")
                    }
                    ForEach(vm.alphaLanguages) {
                        alphaLanguage in
                        NavigationLink {
                            AlphaLanguageEditorView(alphaLanguage: alphaLanguage, preview: preview)
                        } label: {
                            Text(alphaLanguage.decoded.name)
                        }
                    }
                    .onDelete(perform: vm.deleteAlphas)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button{
                    vm.hardAlphaRefresh()
                    vm.hardLogoRefresh()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                EditButton()
            }
        }
        .onAppear(perform: vm.refresh)
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
