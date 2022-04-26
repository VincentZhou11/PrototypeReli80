//
//  PhonemeChooserView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/26/22.
//

import SwiftUI
import AVFoundation

struct PhonemeChooserView: View {
    
    @StateObject var vm: PhonemeChooserViewModel
    
    init() {
        _vm = StateObject(wrappedValue: PhonemeChooserViewModel())
    }
    
    var body: some View {
        ScrollView {
//            Text(vm.text).font(.largeTitle)
            GroupBox {
                Divider()
                ConsonantView(vm: vm)
            } label: {
                Text("Consonants")
            }
            GroupBox {
                Divider()
                VowelView(vm: vm)
            } label: {
                Text("Vowels")
            }
            GroupBox {
                Divider()
                ForeignView(vm: vm)
            } label: {
                Text("Foreign Phonemes")
            }
            GroupBox {
                Divider()
                NasalView(vm: vm)
            } label: {
                Text("Nasal Vowels")
            }
        }
        .padding()
        .popover(isPresented: $vm.popOver) {
            Text("Your content here")
                .font(.headline)
                .padding()
        }
        
    }
}

struct PhonemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        PhonemeChooserView().preferredColorScheme(.dark)
    }
}
struct PhonemeButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width:45, height:30).background(.thickMaterial).cornerRadius(5)
    }
}
struct ConsonantView: View {
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 45))]
    var vm: PhonemeChooserViewModel
    
    var body: some View {
        LazyVGrid(columns: rows, alignment:.leading, spacing: 2) {
            ForEach(Array(LanguageUtils.consonants.keys), id: \.self) {
                consonantKey in
                Button {
                    
                } label: {
                    Text(consonantKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(LongPressGesture(minimumDuration: 2).onEnded({ action in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = consonantKey
                }))
//                .buttonStyle(.plain).frame(width:45, height:25).background(.thickMaterial).cornerRadius(5)
//                HStack {
//                    ForEach(LanguageUtils.consonants[consonantKey]!, id: \.self) {
//                        word in
//                        Text(word)
//                    }
//                }
            }
        }
    }
}
struct VowelView: View {
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 45))]
    var vm: PhonemeChooserViewModel
    
    var body: some View {
        LazyVGrid(columns: rows, alignment:.leading, spacing: 2) {
            ForEach(Array(LanguageUtils.vowels.keys), id: \.self) {
                vowelKey in
                Button {

                } label: {
                    Text(vowelKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(LongPressGesture(minimumDuration: 2).onEnded({ action in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = vowelKey
                }))
            }
        }
    }
}
struct ForeignView: View {
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 45))]
    var vm: PhonemeChooserViewModel
    
    var body: some View {
        LazyVGrid(columns: rows, alignment:.leading, spacing: 2) {
            ForEach(Array(LanguageUtils.foreign.keys), id: \.self) {
                foreignKey in
                Button {

                } label: {
                    Text(foreignKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(LongPressGesture(minimumDuration: 2).onEnded({ action in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = foreignKey
                }))
            }
        }
    }
}
struct NasalView: View {
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 45))]
    var vm: PhonemeChooserViewModel
    
    var body: some View {
        LazyVGrid(columns: rows, alignment:.leading, spacing: 2) {
            ForEach(Array(LanguageUtils.nasalizedVowels.keys), id: \.self) {
                nasalKey in
                Button {

                } label: {
                    Text(nasalKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(LongPressGesture(minimumDuration: 2).onEnded({ action in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = nasalKey
                }))
            }
        }
    }
}
