//
//  LanguageEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData
import SwiftUI

public class LanguageEditorViewModel: ObservableObject {
    // Updating managed object
    // https://stackoverflow.com/questions/28525962/how-to-update-existing-objects-in-core-data
    
    private var viewContext: NSManagedObjectContext
    
    @Published var logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>

    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        let logograms = [Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
                         Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
                         Logogram(drawing: Drawing.example, meaning: "Test Logogram 3")]
        
        let decoded = LogographicLanguage(name: "New Language", logograms: logograms)
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
            var newDrawing = Drawing.empty
            newDrawing.color = .red
            
            let newLogogram = Logogram(drawing: newDrawing, meaning: "New Logogram")
            logoLanguage.decoded.logograms.append(newLogogram)
            
//            save()
        }
//        refresh()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map{logoLanguage.decoded.logograms.remove(at: $0)}
//            save()
        }
//        refresh()
    }
}
