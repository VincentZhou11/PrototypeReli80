//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageEditorView: View {
    @StateObject var vm = LanguageEditorViewModel()
    
    init(preview: Bool = false) {
        _vm = StateObject<LanguageEditorViewModel>(wrappedValue: LanguageEditorViewModel(preview: preview))
    }
    
    var body: some View {
        Form {
            List {
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "trash").foregroundColor(.red)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct LanguageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LanguageEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
