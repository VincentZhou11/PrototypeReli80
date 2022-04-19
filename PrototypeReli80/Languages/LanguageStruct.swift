//
//  LanguageStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation

struct DecodedWithManagedObject<E,F>: Identifiable {
    var id: UUID
    var decoded: E
    var managedObject: F
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
