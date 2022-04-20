//
//  SentenceStruct.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation

struct LogographicSentence: Identifiable, Codable {
    var id = UUID()
    var timestamp = Date()
    var sentence: [Logogram]
    var language: LogographicLanguage
}
extension LogographicSentence {
    static var example: LogographicSentence {
        let logograms = [
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 1"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 2"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 3"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 4"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 5"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 6"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 7"),
            Logogram(drawing: Drawing.example, meaning: "Test Logogram 8")
        ]
        return LogographicSentence(sentence: logograms, language: .example)
    }
}
