//
//  Persistence.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Languages
        for i in 0..<10 {
            do {
                let newLanguage = LogographicLanguageDB(context: viewContext)
                
                let logograms = [Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
                                 Logogram(drawing: Drawing.example, meaning: "Test Logogram 3")]
                
                let newLanguageStruct = LogographicLanguage(
                    name: "Test Language \(i)",
                    logograms: logograms
                )
                
                newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
                newLanguage.timestamp = newLanguageStruct.timestamp
                newLanguage.id = newLanguageStruct.id
            }
            catch {
                fatalError("Failed to encode JSON \(error.localizedDescription)")
            }
        }
        // Sentences
        for i in 0..<10 {
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
                fatalError("Failed to encode JSON \(error.localizedDescription)")
            }
        }
        // Save
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JSONLanguageDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
