//
//  LanguageEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData
import Combine
import SwiftUI

public class LanguageMenuViewModel: ObservableObject {
    @Published var logoLanguages: [DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>] = []
    
//    @Published var decodedLogoLanguages: [LogographicLanguage] = []
//    @Published var fetchedLogoLanguages: [LogographicLanguageDB] = []
    
    private var viewContext: NSManagedObjectContext
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        refresh()
    }
    
    func refresh() {
        // https://agiokas.medium.com/core-data-and-async-await-thread-safe-f96b6dbbb7c4
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
                let newLanguage = LogographicLanguageDB(context: viewContext)
                let logograms = [Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 3")]
                
                let newLanguageStruct = LogographicLanguage(name: "Test Language", logograms: logograms)
                newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
                newLanguage.timestamp = newLanguageStruct.timestamp
                newLanguage.id = newLanguageStruct.id
            }
            catch {
                print("Failed to encode JSON \(error.localizedDescription)")
            }

            save()
        }
        refresh()
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { logoLanguages[$0].managedObject }.forEach(viewContext.delete)
            save()
        }
        refresh()
    }
}

