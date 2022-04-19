//
//  LanguageStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData

//
struct DecodedWithManagedObject<E,F>: Identifiable {
    var id: UUID
    var decoded: E
    var managedObject: F
}

// Better attempt to synchronous struct with managed object
struct SyncObject<E: Codable, F>: Identifiable where F: NSManagedObject, F:JSONData {
    var id: UUID
    var decoded: E
    var managedObject: F
    var viewContext: NSManagedObjectContext
    
    mutating func updateDecoded() {
        do {
            decoded = try JSONDecoder().decode(E.self, from: managedObject.jsonData)
        }
        catch {
            print("Decoded update error \(error.localizedDescription)")
        }
    }
    mutating func updateManagedObject() {
        do {
            managedObject.jsonData = try JSONEncoder().encode(decoded)
            try viewContext.save()
        } catch {
            print("Managed object update error \(error.localizedDescription)")
        }
    }
}
protocol JSONData {
    var jsonData: Data {get set}
}

extension LogographicLanguageDB: JSONData {
    var jsonData: Data {
        get {
            self.data!
        }
        set {
            self.data = newValue
        }
    }
}

struct LogographicLanguage: Identifiable, Codable {
    var id = UUID()
    var timestamp = Date()
    var name: String
    var logograms: [Logogram]
}
extension LogographicLanguage {
    static var example: LogographicLanguage {
        LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
    }
}

struct Logogram: Identifiable, Codable {
    var id = UUID()
    var drawing: Drawing
    var meaning: String
}
extension Logogram {
    static var example: Logogram {
        Logogram(drawing: Drawing.example, meaning: "Test Logogram")
    }
}

