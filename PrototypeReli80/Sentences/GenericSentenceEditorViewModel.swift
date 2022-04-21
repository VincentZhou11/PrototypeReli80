//
//  GenericSentenceEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import Foundation
import CoreData
import SwiftUI

class GenericSentenceEditorViewModel<GenericSentence: MorphemeSentence, GenericSentenceDB: NSManagedObject & JSONData>: ObservableObject {
    
    var viewContext: NSManagedObjectContext
    
    @Published var sentence: SyncObject<GenericSentence, GenericSentenceDB>
    
    @Published var editSheet = false
    @Published var newSheet = false
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        let decoded = AlphabetSentence.example
        var managedObject = GenericSentenceDB(context: viewContext)
        managedObject.jsonTimestamp = decoded.timestamp
        managedObject.jsonId = decoded.id
        do {
            managedObject.jsonData = try JSONEncoder().encode(decoded)
        }
        catch {
            fatalError("Failed to encode JSON \(error.localizedDescription)")
        }
        self.sentence = SyncObject<GenericSentence, GenericSentenceDB>(decoded: decoded as! GenericSentence, managedObject: managedObject, viewContext: viewContext)
        save()
    }
    init(sentence: SyncObject<GenericSentence, GenericSentenceDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.sentence = sentence
    }
    func refresh() {
        withAnimation {
            sentence.updateDecoded()
        }
    }
    func save() {
        sentence.saveManagedObject()
    }
    
}

