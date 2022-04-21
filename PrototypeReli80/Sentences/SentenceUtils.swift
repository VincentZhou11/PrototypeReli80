//
//  SentenceUtils.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import SwiftUI


protocol Morpheme: Identifiable, Codable {    
    var id: UUID {get}
    
    var morphemeMeaning: String {get}
    var morpheneDrawing: [Drawing] {get}
    
    func copy() -> Self
}
protocol Morphemes: Identifiable, Codable {
    associatedtype MorphemeType: Morpheme
    
    var id: UUID {get}
    var timestamp: Date {get}
    var name: String {get}
    
    var morphemes: [MorphemeType] {get set}
}
protocol MorphemeSentence: Identifiable, Codable {
    associatedtype MorphemeType: Morpheme
    associatedtype MorphemesType: Morphemes
    
    var id: UUID {get}
    var timestamp: Date {get}
    
    
    var sentence: [MorphemeType] {get set}
    var language: MorphemesType {get set}
}
