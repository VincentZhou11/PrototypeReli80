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
    var morphemes: [Logogram]
}
extension LogographicLanguage {
    static var example: LogographicLanguage {
        LogographicLanguage(name: "Example Language", morphemes: [.example, .example, .example])
    }
    static var new: LogographicLanguage {
        LogographicLanguage(name: "New Language", morphemes: [])
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
    func copy() -> Logogram {
        Logogram(drawing: drawing, meaning: meaning)
    }
}
extension Logogram {
    static var example: Logogram {
        Logogram(drawing: Drawing.example, meaning: "Example Logogram")
    }
}
// Alphabet
struct AlphabetLanguage: Identifiable, Codable, Morphemes {
    var id = UUID()
    var timestamp = Date()
    var name: String
    var morphemes: [Word]
    var letters: [Letter]
}
extension AlphabetLanguage {
    static var example:AlphabetLanguage {
        AlphabetLanguage(name: "Example Language", morphemes: [.example], letters: [.example, .example, .example])
    }
    static var new:AlphabetLanguage {
        AlphabetLanguage(name: "New Language", morphemes: [], letters: [])
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
    func copy() -> Word {
        Word(meaning: meaning, spelling: spelling)
    }
}
extension Word {
    static var example: Word {
        Word(meaning: "Example Word", spelling: [.example, .example, .example])
    }
}
struct Letter: Identifiable, Codable {
    var id = UUID()
    var drawing: Drawing
    var pronounciation: String
}
extension Letter {
    static var example: Letter {
        Letter(drawing: .example, pronounciation: "Example Letter")
    }
    func copy() -> Letter {
        Letter(drawing: drawing, pronounciation: pronounciation)
    }
}

