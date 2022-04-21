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
    
    private var viewContext: NSManagedObjectContext
    
    @Published var logoLanguages: [SyncObject<LogographicLanguage, LogographicLanguageDB>] = []
    @Published var alphaLanguages: [SyncObject<AlphabetLanguage, AlphabetLanguageDB>] = []

    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        
        hardLogoRefresh()
        hardAlphaRefresh()
    }
    func refresh() {
        DispatchQueue.main.async {
            for index in self.logoLanguages.indices {
                self.logoLanguages[index].updateDecoded()
            }
            for index in self.alphaLanguages.indices {
                self.alphaLanguages[index].updateDecoded()
            }
        }
    }
    func hardAlphaRefresh() {
        // https://agiokas.medium.com/core-data-and-async-await-thread-safe-f96b6dbbb7c4
        Task {
            do {
                // Create Fetch request
                let fetchRequest = AlphabetLanguageDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AlphabetLanguageDB.timestamp, ascending: true)]
                // Fetch
                let fetchedLogoLanguages = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                // Create the necessary structs
                let structs: [SyncObject<AlphabetLanguage, AlphabetLanguageDB>] = try fetchedLogoLanguages.compactMap {
                    managedObjectLanguage in
                    let decodedLanguage = try JSONDecoder().decode(AlphabetLanguage.self, from: managedObjectLanguage.data!)
                    return SyncObject(decoded: decodedLanguage, managedObject: managedObjectLanguage, viewContext: viewContext)
                }
                // Update view
                DispatchQueue.main.async {
                    withAnimation {
                        self.alphaLanguages = structs
                    }
                }
            }
            catch {
                print("Alpha refersh error: \(error.localizedDescription)")
            }
        }
    }
    func hardLogoRefresh() {
        // https://agiokas.medium.com/core-data-and-async-await-thread-safe-f96b6dbbb7c4
        Task {
            do {
                // Create Fetch request
                let fetchRequest = LogographicLanguageDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LogographicLanguageDB.timestamp, ascending: true)]
                // Fetch
                let fetchedLogoLanguages = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                // Create the necessary structs
                let structs: [SyncObject<LogographicLanguage, LogographicLanguageDB>] = try fetchedLogoLanguages.compactMap {
                    managedObjectLanguage in
                    let decodedLanguage = try JSONDecoder().decode(LogographicLanguage.self, from: managedObjectLanguage.data!)
                    return SyncObject(decoded: decodedLanguage, managedObject: managedObjectLanguage, viewContext: viewContext)
                }
                // Update view
                DispatchQueue.main.async {
                    withAnimation {
                        self.logoLanguages = structs
                    }
                }
            }
            catch {
                print("Logo refersh error: \(error.localizedDescription)")
            }
        }
    }
    func save() {
        viewContext.perform {
            do {
                try self.viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Language Menu save error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func createDummyLanguage() {
        do {
            let newLanguageStruct = LogographicLanguage.example
            let newLanguage = LogographicLanguageDB(context: viewContext)
            newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
            newLanguage.timestamp = newLanguageStruct.timestamp
            newLanguage.id = newLanguageStruct.id
        }
        catch {
            print("Failed to encode JSON \(error.localizedDescription)")
        }
    }
    
    
    
    func createAlphaLanguage() {
        do {
            // Create empty language
            let newLanguageStruct = AlphabetLanguage.new
            let newLanguage = AlphabetLanguageDB(context: viewContext)
            newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
            newLanguage.timestamp = newLanguageStruct.timestamp
            newLanguage.id = newLanguageStruct.id
        }
        catch {
            print("Failed to encode JSON \(error.localizedDescription)")
        }
    }
    
    func addAlpha() {
        withAnimation {
//            createDummyLanguage()
            createAlphaLanguage()
            save()
        }
        hardAlphaRefresh()
    }

    func deleteAlphas(offsets: IndexSet) {
        withAnimation {
            offsets.map { alphaLanguages[$0].managedObject }.forEach(viewContext.delete)
            save()
        }
        hardAlphaRefresh()
    }
    
    func createLogoLanguage() {
        do {
            // Create empty language
            let newLanguageStruct = LogographicLanguage.new
            let newLanguage = LogographicLanguageDB(context: viewContext)
            newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
            newLanguage.timestamp = newLanguageStruct.timestamp
            newLanguage.id = newLanguageStruct.id
        }
        catch {
            print("Failed to encode JSON \(error.localizedDescription)")
        }
    }
    
    func addLogo() {
        withAnimation {
//            createDummyLanguage()
            createLogoLanguage()
            save()
        }
        hardLogoRefresh()
    }

    func deleteLogos(offsets: IndexSet) {
        withAnimation {
            offsets.map { logoLanguages[$0].managedObject }.forEach(viewContext.delete)
            save()
        }
        hardLogoRefresh()
    }
    
    func destroyDB(preview: Bool) {
        let persistentContainer = preview ? PersistenceController.preview.container : PersistenceController.shared.container
        
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
            
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }
}

