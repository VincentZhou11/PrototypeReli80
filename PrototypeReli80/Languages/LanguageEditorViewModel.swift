//
//  LanguageEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData

public class LanguageEditorViewModel: ObservableObject {
    // Updating managed object
    // https://stackoverflow.com/questions/28525962/how-to-update-existing-objects-in-core-data
    
    private var viewContext: NSManagedObjectContext
    
    var logoLanguage: LogographicLanguage
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        self.logoLanguage = LogographicLanguage(name: "New Language", logograms: [])
    }
    init(preview: Bool = false, logoLanguage: LogographicLanguage, managedLogoLanguage: LogographicLanguageDB) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        self.logoLanguage = logoLanguage
    }
}
