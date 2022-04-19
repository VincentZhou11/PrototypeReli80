//
//  SentenceMenuViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import CoreData
import SwiftUI

public class SentenceMenuViewModel:ObservableObject {
    @Published var logoSentences: [DecodedWithManagedObject<LogographicSentence, LogographicSentenceDB>] = []
    @Published var logoLanguages: [DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>] = []
    
    private var viewContext: NSManagedObjectContext
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        refreshLanguages()
        refreshSentences()
    }
    func refreshSentences() {
        // https://agiokas.medium.com/core-data-and-async-await-thread-safe-f96b6dbbb7c4
        Task {
            do {
                let fetchRequest = LogographicSentenceDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LogographicSentenceDB.timestamp, ascending: true)]
                
                let fetchedLogoSentences = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                let decoder = JSONDecoder()
                let structs: [DecodedWithManagedObject<LogographicSentence, LogographicSentenceDB>] = try fetchedLogoSentences.compactMap {
                    managedObjectSentence in
                    let decodedSentence = try decoder.decode(LogographicSentence.self, from: managedObjectSentence.data!)
                    return DecodedWithManagedObject(id: decodedSentence.id, decoded: decodedSentence, managedObject: managedObjectSentence)
                }
                DispatchQueue.main.async {
                    withAnimation {
                        self.logoSentences = structs
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    func refreshLanguages() {
        Task {
            do {
                let fetchRequest = LogographicLanguageDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LogographicLanguageDB.timestamp, ascending: true)]
                
                let fetchedLogoLanguages = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                let structs: [DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>] = try fetchedLogoLanguages.compactMap {
                    managedObjectLanguage in
                    let decodedLanguage = try JSONDecoder().decode(LogographicLanguage.self, from: managedObjectLanguage.data!)
                    return DecodedWithManagedObject(id: decodedLanguage.id, decoded: decodedLanguage, managedObject: managedObjectLanguage)
                }
                DispatchQueue.main.async {
                    withAnimation {
                        self.logoLanguages = structs
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Language Menu save error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addItem() {
        withAnimation {
//            createDummyLanguage()
            
            do {
                let newSentence = LogographicSentenceDB(context: viewContext)
                let logograms = [Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 3")]
                
                let newSentenceStruct = LogographicSentence(sentence: logograms)
                newSentence.data = try JSONEncoder().encode(newSentenceStruct)
                newSentence.timestamp = newSentenceStruct.timestamp
                newSentence.id = newSentenceStruct.id
            }
            catch {
                print("Failed to encode JSON \(error.localizedDescription)")
            }

            save()
        }
        refreshSentences()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { logoSentences[$0].managedObject }.forEach(viewContext.delete)
            save()
        }
        refreshSentences()
    }
}
