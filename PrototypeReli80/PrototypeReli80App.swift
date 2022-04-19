//
//  PrototypeReli80App.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 3/26/22.
//

import SwiftUI

@main
struct PrototypeReli80App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
