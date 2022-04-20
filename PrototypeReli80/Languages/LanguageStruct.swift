//
//  LanguageStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData

struct LogographicLanguage: Identifiable, Codable, Morphemes {
    var id = UUID()
    var timestamp = Date()
    var name: String
    var logograms: [Logogram]
    
    var morphemes: [Logogram] {
        logograms
    }
}
extension LogographicLanguage {
    static var example: LogographicLanguage {
        LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
    }
}

struct Logogram: Identifiable, Codable, Morpheme {
    var id = UUID()
    var drawing: Drawing
    var meaning: String
    
    var morphemeMeaning: String {
        meaning
    }
    var morpheneDrawing: [Drawing] {
        [drawing]
    }
}
extension Logogram {
    static var example: Logogram {
        Logogram(drawing: Drawing.example, meaning: "Test Logogram")
    }
    func copy() -> Logogram {
        return Logogram(drawing: drawing, meaning: meaning)
    }
}

