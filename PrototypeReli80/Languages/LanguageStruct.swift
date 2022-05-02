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
        LogographicLanguage(name: "Example Logographic Script", morphemes: [.example, .example, .example])
    }
    static var new: LogographicLanguage {
        LogographicLanguage(name: "New Logographic Script", morphemes: [])
    }
}
struct Logogram: Identifiable, Codable, Morpheme {
    var id = UUID()
    var drawing: Drawing
    var meaning: String
    var pronunciation: String
    
    var morphemePronunciation: String {
        pronunciation
    }
    var morphemeMeaning: String {
        meaning
    }
    var morpheneDrawing: [Drawing] {
        [drawing]
    }
    func copy() -> Logogram {
        Logogram(drawing: drawing, meaning: meaning, pronunciation: pronunciation)
    }
}
extension Logogram {
    static var example: Logogram {
        Logogram(drawing: .example, meaning: "Example Logogram", pronunciation: "Example pronunciation")
    }
    static var new: Logogram {
        Logogram(drawing: .empty, meaning: "New Logogram", pronunciation: "")
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
        AlphabetLanguage(name: "Example Alphabetic Script", morphemes: [.example], letters: [.example, .example, .example])
    }
    static var new:AlphabetLanguage {
        AlphabetLanguage(name: "New Alphabetic Script", morphemes: [], letters: [])
    }
}
struct Word: Identifiable, Codable, Morpheme {
    var id = UUID()
    var meaning: String
    var spelling: [Letter]
    
    var morphemePronunciation: String {
        return spelling.reduce ("",{
            x, y in
            x + y.pronunciation + " "
        }).trimmingCharacters(in: .whitespaces)
    }
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
    static var new: Word {
        Word(meaning: "New Word", spelling: [])
    }
}
struct Letter: Identifiable, Codable {
    var id = UUID()
    var drawing: Drawing
    var pronunciation: String
    
    func copy() -> Letter {
        Letter(drawing: drawing, pronunciation: pronunciation)
    }
}
extension Letter {
    static var example: Letter {
        Letter(drawing: .example, pronunciation: "/e/")
    }
    static var new: Letter {
        Letter(drawing: .empty, pronunciation: "//")
    }
}

