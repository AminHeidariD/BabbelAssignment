//
//  WordModel.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

struct WordModel: Decodable {
    let originalText: String?
    let translatedText: String?
    
    init(originalText: String?, translatedText: String?) {
        self.originalText = originalText
        self.translatedText = translatedText
    }
    enum CodingKeys: String, CodingKey {
        case originalText = "text_eng"
        case translatedText = "text_spa"
    }
    
    static func == (lhs: WordModel, rhs: WordModel) -> Bool {
        return lhs.originalText == rhs.originalText && lhs.translatedText == rhs.translatedText
    }
}

