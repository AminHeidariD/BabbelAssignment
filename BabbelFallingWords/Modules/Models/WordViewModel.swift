//
//  WordModel.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

struct WordViewModel {
    
    private(set) var questionNumber: Int
    private let word: WordModel
    private let totalQuestionNumber: Int
    private let isTranslatedWordCorrect: Bool
    //
    var wordTitle: String? {
        return word.originalText
    }
    
    var translatedWordTitle: String? {
        return word.translatedText
    }
    
    var questionNumberTitle: String? {
        return "\(questionNumber)/\(totalQuestionNumber)"
    }
    //
    init(word: WordModel, isTranslatedWordCorrect: Bool, questionNumber: Int, totalQuestionNumber: Int) {
        self.word = word
        self.questionNumber = questionNumber
        self.totalQuestionNumber = totalQuestionNumber
        self.isTranslatedWordCorrect = isTranslatedWordCorrect
    }
}

extension WordViewModel {
    func checkAnswer(with action: AnswerAction) -> AnswerAction {
        switch action {
        case .correct:
            return isTranslatedWordCorrect ? .correct : .wrong
        case .wrong:
            return isTranslatedWordCorrect ? .wrong : .correct
        case .notAnswered:
            return .notAnswered
        }
    }
}
