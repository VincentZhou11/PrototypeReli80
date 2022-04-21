//
//  SentenceStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation

struct LogographicSentence: Identifiable, Codable, MorphemeSentence {
    var id = UUID()
    var timestamp = Date()
    var sentence: [Logogram]
    var language: LogographicLanguage
}
extension LogographicSentence {
    static var example: LogographicSentence {
        let logograms = [
            Logogram.example,
            Logogram.example,
            Logogram.example
        ]
        return LogographicSentence(sentence: logograms, language: .example)
    }
}
struct AlphabetSentence: Identifiable, Codable, MorphemeSentence {
    var id = UUID()
    var timestamp = Date()
    var sentence: [Word]
    var language: AlphabetLanguage
}
extension AlphabetSentence {
    static var example: AlphabetSentence {
        let words = [
            Word.example,
            Word.example,
            Word.example
        ]
        return AlphabetSentence(sentence: words, language: .example)
    }
}

