//
//  ContentView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 3/26/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
//        NavigationView {
            TabView {
                NavigationView {
                    GenericSentenceMenuView()
                }
                .tabItem {
                    Label("Sentence Menu", systemImage: "doc.on.doc")
                }
                NavigationView {
                    LanguageMenuView()
                }
                .tabItem {
                    Label("Language Menu", systemImage: "gear")
                }
//                DrawingTestingView().tabItem {
//                    Label("Drawing Test", systemImage: "pencil")
//                }
//                RealityKitView(sentence: LogographicSentence.example).tabItem {
//                    Label("AR", systemImage: "iphone")
//                }.ignoresSafeArea()
                NavigationView {
                    RKSentenceChooserView()
                }.tabItem {
                    Label("AR", systemImage: "iphone")
                }
            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
