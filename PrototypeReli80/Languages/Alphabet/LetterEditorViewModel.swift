//
//  LetterEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import Foundation
import CoreData
import SwiftUI

public class LetterEditorViewModel: ObservableObject {
    
    private var viewContext: NSManagedObjectContext
    
    @Published var alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>
//    @Published var logogram: Logogram
    @Published var idx: Int
    @Published var phonemeSheet = false
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
                
        let decoded = AlphabetLanguage.example
        let managedObject = AlphabetLanguageDB(context: viewContext)
        managedObject.id = decoded.id
        managedObject.timestamp = decoded.timestamp
        do {
            managedObject.data = try JSONEncoder().encode(decoded)
        }
        catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
        }
        
        self.idx = 0
        self.alphaLanguage = SyncObject(decoded: decoded, managedObject: managedObject, viewContext: viewContext)
        
        save()
    }
    init(idx: Int, alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
                
//        self.logogram = logoLanguage.decoded.logograms[idx]
        self.alphaLanguage = alphaLanguage
        self.idx = idx
        
        
    }
    
    func onSubmit(newDrawing: Drawing) {
        alphaLanguage.decoded.letters[idx].drawing = newDrawing
//        logogram = logoLanguage.decoded.logograms[idx]
//        save()
    }
    func save() {
        alphaLanguage.saveManagedObject()
    }
//    func delete() {
//
//    }
}
