//
//  LogogramEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import CoreData
import SwiftUI

public class LogogramEditorViewModel: ObservableObject {
    
    private var viewContext: NSManagedObjectContext
    
    @Published var logoLanguage: DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>
    @Published var logogram: Logogram
    @Published var idx: Int
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        let newLogogram = Logogram(drawing: .example, meaning: "Something")
        
        self.idx = 0
        self.logogram = newLogogram
        let logograms = [newLogogram]
        
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
    init(idx: Int, logoLanguage: DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.logogram = logoLanguage.decoded.logograms[idx]
        self.logoLanguage = logoLanguage
        self.idx = idx
    }
    
    func onSubmit(newDrawing: Drawing) {
        logoLanguage.decoded.logograms[idx].drawing = newDrawing
        logogram = logoLanguage.decoded.logograms[idx]
        save()
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
            logoLanguage.managedObject.data = try JSONEncoder().encode(logoLanguage.decoded)
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Logogram Editor save error \(nsError), \(nsError.userInfo)")
        }
    }
}
