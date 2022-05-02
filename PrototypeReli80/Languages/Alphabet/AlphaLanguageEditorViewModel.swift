//
//  AlphaLanguageEditorViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/20/22.
//

import Foundation

import Foundation
import CoreData
import SwiftUI

public class AlphaLanguageEditorViewModel: ObservableObject {
    // Updating managed object
    // https://stackoverflow.com/questions/28525962/how-to-update-existing-objects-in-core-data
    
    private var viewContext: NSManagedObjectContext
    
    @Published var alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>

    
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
        
        self.alphaLanguage = SyncObject(decoded: decoded, managedObject: managedObject, viewContext: viewContext)
        
        save()
    }
    init(alphaLanguage: SyncObject<AlphabetLanguage, AlphabetLanguageDB>, preview: Bool = false) {
        if preview {viewContext = PersistenceController.preview.container.viewContext}
        else {viewContext = PersistenceController.shared.container.viewContext}
        
        self.alphaLanguage = alphaLanguage
    }
    
    
    func refresh() {
        alphaLanguage.updateDecoded()
    }
    
    func save() {
        alphaLanguage.saveManagedObject()
    }
    
    func addWord() {
        withAnimation {
            let newLogogram = Word.new
            alphaLanguage.decoded.morphemes.append(newLogogram)
            
//            save()
        }
//        refresh()
    }

    func deleteWords(offsets: IndexSet) {
        withAnimation {
            let _ = offsets.map{alphaLanguage.decoded.morphemes.remove(at: $0)}
//            save()
        }
//        refresh()
    }
    
    func addLetter() {
        withAnimation {
            let newLogogram = Letter.new
            alphaLanguage.decoded.letters.append(newLogogram)
            
//            save()
        }
//        refresh()
    }

    func deleteLetters(offsets: IndexSet) {
        withAnimation {
            let _ = offsets.map{alphaLanguage.decoded.letters.remove(at: $0)}
//            save()
        }
//        refresh()
    }
}

