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
    var sentence: [Logogram] = []
}
