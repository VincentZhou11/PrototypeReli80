//
//  LanguageStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import Foundation
import CoreData

// Logograph
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
        Logogram(drawing: drawing, meaning: meaning)
    }
}
// Alphabet
struct AlphabetLanguage: Identifiable, Codable, Morphemes {
    var id = UUID()
    var timestamp = Date()
    var name: String
    var words: [Word]
    var letters: [Letter]
    
    var morphemes: [Word] {
        words
    }
}
extension AlphabetLanguage {
    static var example:AlphabetLanguage {
        AlphabetLanguage(name: "Example", words: [.example, .example, .example], letters: [.example])
    }
}
struct Word: Identifiable, Codable, Morpheme {
    var id = UUID()
    var meaning: String
    var spelling: [Letter]
    
    var morphemeMeaning: String {
        meaning
    }
    var morpheneDrawing: [Drawing] {
        let drawings = spelling.map {$0.drawing}
        return drawings
    }
}
extension Word {
    static var example: Word {
        Word(meaning: "Example", spelling: [.example, .example, .example])
    }
}
struct Letter: Identifiable, Codable {
    var id = UUID()
    var drawing: Drawing
    var pronounciation: String
}
extension Letter {
    static var example: Letter {
        Letter(drawing: .example, pronounciation: "Example")
    }
    func copy() -> Letter {
        Letter(drawing: drawing, pronounciation: pronounciation)
    }
}

