//
//  LanguageEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData
import SwiftUI

public class LogoLanguageEditorViewModel: ObservableObject {
    // Updating managed object
    // https://stackoverflow.com/questions/28525962/how-to-update-existing-objects-in-core-data
    
    private var viewContext: NSManagedObjectContext
    
    @Published var logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>

    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}

        
        let decoded = LogographicLanguage.example
        let managedObject = LogographicLanguageDB(context: viewContext)
        managedObject.id = decoded.id
        managedObject.timestamp = decoded.timestamp
        do {
            managedObject.data = try JSONEncoder().encode(decoded)
        }
        catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
        }
        
        self.logoLanguage = SyncObject(decoded: decoded, managedObject: managedObject, viewContext: viewContext)
        
        save()
    }
    init(logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.logoLanguage = logoLanguage
    }
    
    
    func refresh() {
        logoLanguage.updateDecoded()
    }
    
    func save() {
        logoLanguage.saveManagedObject()
    }
    
    // Change the decoded struct
    func addItem() {
        withAnimation {
//            let newLogogram = Logogram(drawing: Drawing.example, meaning: "Test Logogram")
//            logoLanguage.decoded.logograms.append(newLogogram)
            let newLogogram = Logogram.new
            logoLanguage.decoded.morphemes.append(newLogogram)
            
//            save()
        }
//        refresh()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            let _ = offsets.map{logoLanguage.decoded.morphemes.remove(at: $0)}
//            save()
        }
//        refresh()
    }
}
