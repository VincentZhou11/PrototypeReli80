//
//  SentenceUtils.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation

protocol Morpheme: Identifiable, Codable {
    var id: UUID {get}
    
    var morphemeMeaning: String {get}
    var morpheneDrawing: [Drawing] {get}
}
protocol Morphemes: Identifiable, Codable {
    associatedtype T: Morpheme
    
    var id: UUID {get}
    var timestamp: Date {get}
    
    var morphemes: [T] {get}
}
