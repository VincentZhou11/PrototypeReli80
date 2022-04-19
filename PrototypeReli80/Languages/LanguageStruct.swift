//
//  LanguageStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation

struct LogographicLanguage: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let name: String
    let logograms: [Logogram]
    
    init (id:UUID, timestamp: Date, name: String, logograms: [Logogram]) {
        self.id = id
        self.timestamp = timestamp
        self.name = name
        self.logograms = logograms
    }
    
    init (name: String, logograms: [Logogram]) {
        self.id = UUID()
        self.timestamp = Date()
        self.name = name
        self.logograms = logograms
    }
}
extension LogographicLanguage {
    static let example = LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
}

struct Logogram: Identifiable, Codable {
    let id: UUID
    let drawing: Drawing
    let meaning: String
    
    init(id: UUID, drawing: Drawing, meaning: String) {
        self.id = id
        self.drawing = drawing
        self.meaning = meaning
    }
    init(drawing: Drawing, meaning: String) {
        self.id = UUID()
        self.drawing = drawing
        self.meaning = meaning
    }
}
extension Logogram {
    static let example = Logogram(drawing: Drawing.example, meaning: "Test Drawing")
}
