//
//  TranslateWord.swift
//  cognitive app
//
//  Created by LiQi on 4/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation

/////////////////////////////////////////
struct TranslateWord: Codable {
    var detectedLanguage: DetectedLanguage?
    var translations: [Translations]?
}

struct DetectedLanguage: Codable {
    var language: String?
    var score: Float?
}

struct Translations: Codable {
    var text: String?
    var to: String?
}

struct WordFrom: Codable{
    var text = String()
}
/////////////////////////////////////////

 typealias LanguageCode = String
 struct Language {
    let language: LanguageCode
    let score: Float
}
extension Language: Codable {}

 struct Translation {
    let text: String
    let to: LanguageCode
}
extension Translation: Codable {}

 struct TranslateResult {
    let detectedLanguage: Language?
    let translations: [Translation]
}
extension TranslateResult: Codable {}

