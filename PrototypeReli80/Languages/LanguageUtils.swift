//
//  LanguageUtils.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import Foundation
import CoreData
import SwiftUI





public struct LanguageUtils {
    //https://www.dictionary.com/e/key-to-ipa-pronunciations/
    static let consonants = [
        "/b/" : ["boy", "baby", "rob"],
        "/d/" : ["do", "ladder", "bed"],
        "/dʒ/" : ["jump", "budget", "age"],
        "/f/" : ["food", "offer", "safe"],
        "/g/" : ["get", "bigger", "dog"],
        "/h/" : ["happy", "ahead"],
        "/k/" : ["can", "speaker", "stick"],
        "/l/" : ["let", "follow", "still"],
        "/m/" : ["make", "summer", "time"],
        "/n/" : ["no", "dinner", "thin"],
        "/ŋ/" : ["singer", "think", "long"],
        "/p/" : ["put", "apple", "cup"],
        "/r/" : ["run", "marry", "far", "store"],
        "/s/" : ["sit", "city", "passing", "face"],
        "/ʃ/" : ["she", "station", "push"],
        "/t/" : ["top", "better", "cat"],
        "/tʃ/" : ["church", "watching", "nature", "witch"],
        "/θ/" : ["thirsty", "nothing", "math"],
        "/ð/" : ["this", "mother", "breathe"],
        "/v/" : ["very", "seven", "love"],
        "/w/" : ["wear", "away"],
        "/ʰw/" : ["where", "somewhat"],
        "/y/" : ["yes", "onion"],
        "/z/" : ["zoo", "easy", "buzz"],
        "/ʒ/" : ["measure", "television", "beige"]
    ]
    static let vowels = [
        "/æ/" : ["apple", "can", "hat"],
        "/eɪ/" : ["aid", "hate", "day"],
        "/ɑ/" : ["arm", "father", "aha"],
        "/ɛər/" : ["air", "careful", "wear"],
        "/ɔ/" : ["all", "or", "talk", "lost", "saw"],
        "/aʊər/" : ["hour"],
        "/ɛ/" : ["ever", "head", "get"],
        "/i/" : ["eat", "see", "need"],
        "/ɪər/" : ["ear", "hero", "beer"],
        "/ər/" : ["teacher", "afterward", "murderer"],
        "/ɜr/" : ["early", "bird", "stirring"],
        "/ɪ/" : ["it", "big", "finishes"],
        "/aɪ/" : ["I", "ice", "hide", "deny"],
        "/aɪər/" : ["fire", "tired"],
        "/ɒ/" : ["odd", "hot", "waffle"],
        "/oʊ/" : ["owe", "road", "below"],
        "/u/" : ["ooze", "food", "soup", "sue"],
        "/ʊ/" : ["good", "book", "put"],
        "/ɔɪ/" : ["oil", "choice", "toy"],
        "/aʊ/" : ["out", "loud", "how"],
        "/ʌ/" : ["up", "mother", "mud"],
        "/ə/" : ["about", "animal", "problem", "circus"]
    ]
    static let foreign: [String : [[String : [String]]]] = [
        "/a/" : [["Fr.": ["ami"]]],
        "/ə/" : [["Fr.": ["oeuvre"]]],
        "/œ/" : [
            ["Fr.": ["feu"]],
            ["Ger.": ["schön"]]
        ],
        "/r/" : [
            ["Fr.": ["au", "revoir"]],
            ["Yiddish": ["rebbe"]]
        ],
        "/ü/" : [
            ["Fr.": ["tu"]],
            ["Ger.": ["über"]]
        ],
        "/x/" : [
            ["Scot.": ["loch"]],
            ["Ger.": ["ach","or", "ich"]]
        ],
    ]
    static let nasalizedVowels = [
        "/ɛ̃/" : [["Fr.": "bien"]],
        "/ɑ̃/" : [["Fr.": "croissant"]],
        "/ɔ̃/" : [["Fr.": "bon"]],
        "/œ̃/" : [["Fr.": "parfum"]],
        "/ĩ/" : [["Port.": "Prīncipe"]],
        "/ɪ̃/" : [["Port.": "linguiça"]],
    ]
}
struct NoMarginGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment:.leading) {
            configuration.content
        }
        .padding([.bottom])
        .padding(.top, 40)
//        .background(RoundedRectangle(cornerRadius: 8))
        .overlay(configuration.label.padding(.top, 5).font(.headline), alignment: .topLeading)
    }
}
