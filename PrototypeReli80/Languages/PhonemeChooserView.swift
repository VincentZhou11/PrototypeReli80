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
    init(onSubmit: @escaping (String) -> ()){
        _vm = StateObject(wrappedValue: PhonemeChooserViewModel(onSubmit: onSubmit))
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
                    vm.submit?(consonantKey)
                } label: {
                    Text(consonantKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                //https://stackoverflow.com/questions/58284994/swiftui-how-to-handle-both-tap-long-press-of-button
                .highPriorityGesture(TapGesture().onEnded({ () in
                    vm.submit?(consonantKey)
                }))
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = consonantKey
                }))
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
                    vm.submit?(vowelKey)
                } label: {
                    Text(vowelKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(TapGesture().onEnded({ () in
                    vm.submit?(vowelKey)
                }))
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
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
                    vm.submit?(foreignKey)
                } label: {
                    Text(foreignKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(TapGesture().onEnded({ () in
                    vm.submit?(foreignKey)
                }))
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
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
                    vm.submit?(nasalKey)
                } label: {
                    Text(nasalKey).fontWeight(.light)
                }
                .modifier(PhonemeButtonStyle())
                .highPriorityGesture(TapGesture().onEnded({ () in
                    vm.submit?(nasalKey)
                }))
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    vm.popOver = true
                    vm.selectedInfoPhoneme = nasalKey
                }))
            }
        }
    }
}
