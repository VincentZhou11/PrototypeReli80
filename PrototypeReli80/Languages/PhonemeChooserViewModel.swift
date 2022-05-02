//
//  PhonemeChooserViewModel.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/26/22.
//

import Foundation

class PhonemeChooserViewModel: ObservableObject {
    @Published var text = ""
    @Published var popOver = false
    @Published var selectedInfoPhoneme = ""
    
    var submit: ((String) -> ())?
    
    init() {
        submit = {
            phoneme in
            self.text += phoneme
        }
    }
    init(onSubmit: @escaping (String) -> ()) {
        submit = onSubmit
    }
}
