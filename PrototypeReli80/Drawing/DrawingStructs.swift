//
//  Drawing.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/6/22.
//

import Foundation
import CoreGraphics
import SwiftUI

struct Stroke: Codable {
//    let id = UUID()
    var points: [CGPoint]
}
struct ColorData: Codable {
    var r: Double
    var g: Double
    var b: Double
    var a: Double
}
struct Drawing: Identifiable, Codable {
    var id: UUID
    var strokes: [Stroke]
    var color: Color
    var lineWidth: CGFloat
    
    enum CodingKeys: CodingKey {
        case id
        case strokes
        case color
        case lineWidth
    }
    init(strokes: [Stroke], color: Color, lineWidth: CGFloat) {
        self.id = UUID()
        self.strokes = strokes
        self.color = color
        self.lineWidth = lineWidth
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        strokes = try container.decode([Stroke].self, forKey: .strokes)
        lineWidth = try container.decode(CGFloat.self, forKey: .lineWidth)
        let colorData = try container.decode(ColorData.self, forKey: .color)
        // Problem Child
        color = Color(red: colorData.r, green: colorData.g, blue: colorData.b, opacity: colorData.a)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(strokes, forKey: .strokes)
        try container.encode(lineWidth, forKey: .lineWidth)
        
        // Problem Child
        #if os(iOS)
        let nativeColor = UIColor(color)
        #elseif os(macOS)
        let nativeColor = NSColor(color)
        #endif
        var (r, g, b, a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
        nativeColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        try container.encode(ColorData(r: r, g: g, b: b, a: a), forKey: .color)
    }
}
extension Drawing {
    static var example: Drawing {
        Drawing(strokes: [Stroke(points: [CGPoint(x: 300, y: 300), CGPoint(x: 80, y: 20), CGPoint(x: 20, y: 200), CGPoint(x: 25, y: 25)])], color: .red, lineWidth: 10.0)
    }
    static var empty: Drawing {
        Drawing(strokes: [], color: .black, lineWidth: 3.0)
    }
}
