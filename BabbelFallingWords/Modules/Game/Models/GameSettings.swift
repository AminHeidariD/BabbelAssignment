//
//  GameSettings.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

protocol GameSettingsProtocol {
    var questionCount: Int { get }
    var timeOutDuration: TimeInterval { get }
    func setTotalWords(n: Int)
}

class GameSettings: GameSettingsProtocol {
    
    var questionCount: Int
    var timeOutDuration: TimeInterval
    
    func setTotalWords(n: Int) {
        questionCount = min(questionCount, n)
    }
    
    init (questionCount: Int, timeOutDuration: TimeInterval) {
        self.questionCount = questionCount
        self.timeOutDuration = timeOutDuration
    }
}
