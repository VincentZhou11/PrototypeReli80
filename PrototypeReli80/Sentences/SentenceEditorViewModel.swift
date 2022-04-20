//
//  SentenceEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import CoreData
import SwiftUI

public class SentenceEditorViewModel: ObservableObject {
    var viewContext: NSManagedObjectContext
    
    @Published var sentence: SyncObject<LogographicSentence, LogographicSentenceDB>
    
    @Published var editSheet = false
    @Published var newSheet = false
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        let logograms = [
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 3"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 4"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 5"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 6"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 7"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 8")
        ]
        
        let decoded = LogographicSentence(sentence: logograms, language: .example)
        let managedObject = LogographicSentenceDB(context: viewContext)
        managedObject.timestamp = decoded.timestamp
        managedObject.id = decoded.id
        do {
            managedObject.data = try JSONEncoder().encode(decoded)
        }
        catch {
            fatalError("Failed to encode JSON \(error.localizedDescription)")
        }
        self.sentence = SyncObject<LogographicSentence, LogographicSentenceDB>(decoded: decoded, managedObject: managedObject, viewContext: viewContext)
        save()
    }
    func refresh() {
        withAnimation {
            sentence.updateDecoded()
        }
    }
    func save() {
        sentence.saveManagedObject()
    }
    
    init(sentence: SyncObject<LogographicSentence, LogographicSentenceDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        self.sentence = sentence
    }
}
