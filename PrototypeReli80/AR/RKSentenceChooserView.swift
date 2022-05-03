//
//  RKLanguageChooser.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 5/2/22.
//

import SwiftUI

struct RKSentenceChooserView: View {
    @StateObject var vm = RKSentenceChooserViewModel()
    
    var body: some View {
        Form {
            Section("Logographic Sentences") {
                List {
                    ForEach(vm.logoSentences) {
                        logoSentence in
                        NavigationLink {
                            RealityKitView(sentence: logoSentence.decoded)
                                .ignoresSafeArea()
//                                .navigationBarHidden(true)
                        } label: {
                            GenericSentenceMiniView(sentence: logoSentence)
                        }
                    }
                }
            }
            Section("Alphabet Sentences") {
                List {
                    ForEach(vm.alphaSentences) {
                        alphaSentence in
                        NavigationLink {
                            RealityKitView(sentence: alphaSentence.decoded)
                                .ignoresSafeArea()
//                                .navigationBarHidden(true)
                        } label: {
                            GenericSentenceMiniView(sentence: alphaSentence, cols: 4)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.refresh()
        }
        .navigationBarTitle("AR")
    }
}

struct RKSentenceChooserView_Previews: PreviewProvider {
    static var previews: some View {
        RKSentenceChooserView()
    }
}
