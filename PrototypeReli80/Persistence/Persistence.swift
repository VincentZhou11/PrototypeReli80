//
//  Persistence.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
//            var logograms:[LogogramDB] = []
//            for _ in 0..<10 {
//
//                var strokes: [StrokeDB] = []
//                for stroke in Drawing.sample.strokes {
//                    var points: [PointDB] = []
//                    for point in stroke.points {
//                        let newPoint = PointDB(context: viewContext)
//                        newPoint.x = Float(point.x)
//                        newPoint.y = Float(point.y)
//                        points.append(newPoint)
//                    }
//                    let newStroke = StrokeDB(context: viewContext)
//                    newStroke.id = UUID()
//                    newStroke.points = NSOrderedSet(array: points)
//                    strokes.append(newStroke)
//                }
//                let newColor = ColorDB(context: viewContext)
//                newColor.a = 255.0
//                newColor.r = 255.0
//                newColor.g = 0.0
//                newColor.b = 0.0
//
//                let newDrawing = DrawingDB(context: viewContext)
//                newDrawing.id = UUID()
//                newDrawing.strokes = NSSet(array: strokes)
//                newDrawing.color = newColor
//                newDrawing.lineWidth = 1.0
//
//
//                let newLogogram = LogogramDB(context: viewContext)
//                newLogogram.id = UUID()
//                newLogogram.drawing = newDrawing
//                newLogogram.meaning = "Test"
//
//                logograms.append(newLogogram)
//            }
//            let newLanguage = LogographicLanguageDB(context: viewContext)
//            newLanguage.id = UUID()
//            newLanguage.logograms = NSSet(array: logograms)
//            newLanguage.timestamp = Date()
//            newLanguage.name = "\(i)"
            do {
                let newLanguage = JSONLogographicLanguageDB(context: viewContext)
                let newLanguageStruct = LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
                newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
                newLanguage.timestamp = newLanguageStruct.timestamp
                newLanguage.id = newLanguageStruct.id
            }
            catch {
                fatalError("Failed to encode JSON \(error.localizedDescription)")
            }
            
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JSONLanguageDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
