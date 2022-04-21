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
    
    @Published var logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>
//    @Published var logogram: Logogram
    @Published var idx: Int
    
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
            print("Encoding new data into managed Object failed: \(error.localizedDescription)")
        }
        
        self.idx = 0
        self.logoLanguage = SyncObject(decoded: decoded, managedObject: managedObject, viewContext:viewContext)
            
        save()
    }
    init(idx: Int, logoLanguage: SyncObject<LogographicLanguage, LogographicLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
                
//        self.logogram = logoLanguage.decoded.logograms[idx]
        self.logoLanguage = logoLanguage
        self.idx = idx
        
        
    }
    
    func onSubmit(newDrawing: Drawing) {
        logoLanguage.decoded.morphemes[idx].drawing = newDrawing
//        logogram = logoLanguage.decoded.logograms[idx]
//        save()
    }
    func save() {
        logoLanguage.saveManagedObject()
    }
//    func delete() {
//        
//    }
}
