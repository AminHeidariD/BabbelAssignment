//
//  UserScore.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

struct UserScore {
    private(set) var correctAnswers: Int = 0
    private(set) var wrongAnswers: Int = 0
    private(set) var notAnswered: Int = 0
    
    mutating func AddCorrectAnswer() {
        correctAnswers += 1
    }
    
    mutating func AddWrongAnswer() {
        wrongAnswers += 1
    }
    
    mutating func addNotAnswered() {
        notAnswered += 1
    }
}
