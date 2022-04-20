//
//  Utils.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import CoreData
import SwiftUI

// Better attempt to synchronous struct with managed object
struct SyncObject<E, F>: Identifiable where F: NSManagedObject, F:JSONData, E:Identifiable, E:Codable {
    var id: E.ID
    var decoded: E
    var managedObject: F
    var viewContext: NSManagedObjectContext
    
    init(decoded: E, managedObject: F, viewContext: NSManagedObjectContext) {
        self.id = decoded.id
        self.decoded = decoded
        self.managedObject = managedObject
        self.viewContext = viewContext
    }
    
    mutating func updateDecoded() {
        do {
            decoded = try JSONDecoder().decode(E.self, from: managedObject.jsonData)
        }
        catch {
            print("Decoded update error \(error.localizedDescription)")
        }
    }
    mutating func saveManagedObject() {
        do {
            managedObject.jsonData = try JSONEncoder().encode(decoded)
            try viewContext.save()
        } catch {
            print("Managed object update error \(error.localizedDescription)")
        }
    }
}
protocol JSONData {
    var jsonData: Data {get set}
}

extension LogographicLanguageDB: JSONData {
    var jsonData: Data {
        get {
            self.data!
        }
        set {
            self.data = newValue
        }
    }
}
extension LogographicSentenceDB: JSONData {
    var jsonData: Data {
        get {
            self.data!
        }
        set {
            self.data = newValue
        }
    }
}

// https://stackoverflow.com/a/61149111
public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    public var data: Data
    public var content: (_ index: Data.Index, _ element: Data.Element) -> Content
    var id: KeyPath<Data.Element, ID>

    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo(
                    index: index,
                    id: self.id,
                    element: element
                )
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {
}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, ID>
    let element: Element

    var elementID: ID {
        self.element[keyPath: self.id]
    }

    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }

    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}
