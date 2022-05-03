//
//  RKLanguageChooserViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 5/2/22.
//

import Foundation
import SwiftUI
import CoreData

class RKSentenceChooserViewModel: ObservableObject {
    @Published var logoSentences: [SyncObject<LogographicSentence, LogographicSentenceDB>] = []
    
    @Published var alphaSentences: [SyncObject<AlphabetSentence, AlphabetSentenceDB>] = []
    
    @Published var sheetPresented = false
    
    private var viewContext: NSManagedObjectContext
    
    init(preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        hardRefreshSentences()
    }
    func refresh() {
        hardRefreshSentences()
    }
    
    func hardRefreshSentences() {
        // https://agiokas.medium.com/core-data-and-async-await-thread-safe-f96b6dbbb7c4
        Task {
            do {
                let fetchRequest = LogographicSentenceDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \LogographicSentenceDB.timestamp, ascending: true)]
                
                let fetchedLogoSentences = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                let decoder = JSONDecoder()
                let structs: [SyncObject<LogographicSentence, LogographicSentenceDB>] = try fetchedLogoSentences.compactMap {
                    managedObjectSentence in
                    let decodedSentence = try decoder.decode(LogographicSentence.self, from: managedObjectSentence.data!)
                    return SyncObject(decoded: decodedSentence, managedObject: managedObjectSentence, viewContext: viewContext)
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
        Task {
            do {
                let fetchRequest = AlphabetSentenceDB.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AlphabetSentenceDB.timestamp, ascending: true)]
                
                let fetchedLogoSentences = try await viewContext.perform {
                    try self.viewContext.fetch(fetchRequest)
                }
                
                let decoder = JSONDecoder()
                let structs: [SyncObject<AlphabetSentence, AlphabetSentenceDB>] = try fetchedLogoSentences.compactMap {
                    managedObjectSentence in
                    let decodedSentence = try decoder.decode(AlphabetSentence.self, from: managedObjectSentence.data!)
                    return SyncObject(decoded: decodedSentence, managedObject: managedObjectSentence, viewContext: viewContext)
                }
                DispatchQueue.main.async {
                    withAnimation {
                        self.alphaSentences = structs
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
