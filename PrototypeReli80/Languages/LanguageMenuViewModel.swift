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
                
                
                let decoder = JSONDecoder()
//                let convertedLogoLanguages = try fetchedLogoLanguages.compactMap { try decoder.decode(LogographicLanguage.self, from: $0.data!) }
                
                let structs: [DecodedWithManagedObject<LogographicLanguage, LogographicLanguageDB>] = try fetchedLogoLanguages.compactMap {
                    managedObjectLanguage in
                    let decodedLanguage = try decoder.decode(LogographicLanguage.self, from: managedObjectLanguage.data!)
                    return DecodedWithManagedObject(id: decodedLanguage.id, decoded: decodedLanguage, managedObject: managedObjectLanguage)
                }
                
                
                DispatchQueue.main.async {
                    withAnimation {
//                        self.fetchedLogoLanguages = fetchedLogoLanguages
//                        self.decodedLogoLanguages = convertedLogoLanguages
                        self.logoLanguages = structs
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    public func addItem() {
        withAnimation {
//            createDummyLanguage()
            
            do {
                let newLanguage = LogographicLanguageDB(context: viewContext)
                let newLanguageStruct = LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
                newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
                newLanguage.timestamp = newLanguageStruct.timestamp
                newLanguage.id = newLanguageStruct.id
            }
            catch {
                print("Failed to encode JSON \(error.localizedDescription)")
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        refresh()
    }

    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { logoLanguages[$0].managedObject }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        refresh()
    }
}

