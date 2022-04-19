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
    
    @Published var logoLanguage: DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>
    
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
            print("Encoding new data into managed Object failed: \(error.localizedDescription)")
        }
        
        self.logoLanguage = DecodedWithManagedObject(id: decoded.id, decoded: decoded, managedObject: managedObject)
        
        save()
    }
    init(logoLanguage: DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.logoLanguage = logoLanguage
    }
    
    func refresh() {
        do {
            logoLanguage.decoded = try JSONDecoder().decode(LogographicLanguage.self, from: logoLanguage.managedObject.data!)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func save() {
        do {
            // We change the decoded struct then propagate changes to managed object
            logoLanguage.managedObject.data = try JSONEncoder().encode(logoLanguage.decoded)
            // Save
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Language Editor save error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Change the decoded struct
    func addItem() {
        withAnimation {
            let newLogogram = Logogram(drawing: Drawing.example, meaning: "Test Logogram")
            logoLanguage.decoded.logograms.append(newLogogram)
            save()
        }
        refresh()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map{logoLanguage.decoded.logograms.remove(at: $0)}
            save()
        }
        refresh()
    }
}
