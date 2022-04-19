//
//  LanguageEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/18/22.
//

import SwiftUI

struct LanguageMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: JSONLogographicLanguageDB.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JSONLogographicLanguageDB.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<JSONLogographicLanguageDB>
        
    @StateObject var vm: LanguageMenuViewModel
    
    init(preview: Bool = false) {
        _vm = StateObject<LanguageMenuViewModel>(wrappedValue: LanguageMenuViewModel(preview: preview))
    }
    
    var body: some View {
        Form {
//            Section("Test Logographic Languages") {
//                List {
//                    ForEach(items) {
//                        logographicLanguage in
//                        NavigationLink {
//
//                        } label: {
//                            Text(logographicLanguage.id?.uuidString ?? "" )
//                        }
//                    }
//                    .onDelete(perform: deleteItems)
//                }
//            }
            Section("Logographic Languages") {
                List {
                    ForEach(vm.decodedLogoLanguages) {
                        logographicLanguage in
                        NavigationLink {
                            
                        } label: {
                            Text(logographicLanguage.name)
                        }
                    }
                    .onDelete(perform: vm.deleteItems)
                }
            }
            
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button{
                    vm.addItem()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
//    private func createDummyLanguage() {
//        var logograms:[LogogramDB] = []
//        for _ in 0..<10 {
//
//            var strokes: [StrokeDB] = []
//            for stroke in Drawing.sample.strokes {
//                var points: [PointDB] = []
//                for point in stroke.points {
//                    let newPoint = PointDB(context: viewContext)
//                    newPoint.x = Float(point.x)
//                    newPoint.y = Float(point.y)
//                    points.append(newPoint)
//                }
//                let newStroke = StrokeDB(context: viewContext)
//                newStroke.id = UUID()
//                newStroke.points = NSOrderedSet(array: points)
//                strokes.append(newStroke)
//            }
//            let newColor = ColorDB(context: viewContext)
//            newColor.a = 255.0
//            newColor.r = 255.0
//            newColor.g = 0.0
//            newColor.b = 0.0
//
//            let newDrawing = DrawingDB(context: viewContext)
//            newDrawing.id = UUID()
//            newDrawing.strokes = NSSet(array: strokes)
//            newDrawing.color = newColor
//            newDrawing.lineWidth = 1.0
//
//
//            let newLogogram = LogogramDB(context: viewContext)
//            newLogogram.id = UUID()
//            newLogogram.drawing = newDrawing
//            newLogogram.meaning = "Test"
//
//            logograms.append(newLogogram)
//        }
//        let newLanguage = LogographicLanguageDB(context: viewContext)
//        newLanguage.id = UUID()
//        newLanguage.logograms = NSSet(array: logograms)
//        newLanguage.timestamp = Date()
//        newLanguage.name = "Bruh"
//    }
    
    public func addItem() {
        withAnimation {
//            createDummyLanguage()
            
            do {
                let newLanguage = JSONLogographicLanguageDB(context: viewContext)
                let newLanguageStruct = LogographicLanguage(name: "Test Language", logograms: [.example, .example, .example])
                newLanguage.data = try JSONEncoder().encode(newLanguageStruct)
                newLanguage.timestamp = newLanguageStruct.timestamp
                newLanguage.id = newLanguageStruct.id
            }
            catch {
                print("Failed to encode JSON \(error.localizedDescription)")
            }

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct LanguageMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LanguageMenuView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
