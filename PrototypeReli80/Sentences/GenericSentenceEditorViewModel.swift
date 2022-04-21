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
    
    @Published var languages: [GenericSentence.MorphemesType] = []
    @Published var languageIdx = -1
    
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
        hardRefreshLanguages()
    }
    init(sentence: SyncObject<GenericSentence, GenericSentenceDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.sentence = sentence
        hardRefreshLanguages()
    }
    func refresh() {
        withAnimation {
            sentence.updateDecoded()
        }
    }
    func hardRefreshLanguages() {
        Task {
            do {
                let fetchRequest = LogographicLanguageDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LogographicLanguageDB.timestamp, ascending: true)]
                
                let fetchedLogoLanguages = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                guard let first = fetchedLogoLanguages.first, let sample = try? JSONDecoder().decode(LogographicLanguage.self, from: first.data!), sample is GenericSentence.MorphemesType else {
                    print("Not logo")
                    return
                }

                let structs: [GenericSentence.MorphemesType] = try fetchedLogoLanguages.compactMap {
                    managedObjectLanguage in
                    try JSONDecoder().decode(LogographicLanguage.self, from: managedObjectLanguage.data!) as? GenericSentence.MorphemesType
                }
                DispatchQueue.main.async {
                    withAnimation {
                        self.languages = structs
                    }
                    // Use hash values b/c structs are different
                    if let idx = self.languages.firstIndex(where: { $0.id == self.sentence.decoded.language.id }) {
                        self.languageIdx = idx
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
        Task {
            do {
                let fetchRequest = AlphabetLanguageDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AlphabetLanguageDB.timestamp, ascending: true)]
                
                let fetchedAlphaLanguages = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                guard let first = fetchedAlphaLanguages.first, let sample = try? JSONDecoder().decode(AlphabetLanguage.self, from: first.data!), sample is GenericSentence.MorphemesType else {
                    print("Not Alpha")
                    return
                }

                
                let structs: [GenericSentence.MorphemesType] = try fetchedAlphaLanguages.compactMap {
                    managedObjectLanguage in
                    try JSONDecoder().decode(AlphabetLanguage.self, from: managedObjectLanguage.data!) as? GenericSentence.MorphemesType
                }
                DispatchQueue.main.async {
                    withAnimation {
                        self.languages = structs
                    }
                    if let idx = self.languages.firstIndex(where: { $0.id == self.sentence.decoded.language.id }) {
                        self.languageIdx = idx
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    func save() {
        sentence.saveManagedObject()
    }
    
}

