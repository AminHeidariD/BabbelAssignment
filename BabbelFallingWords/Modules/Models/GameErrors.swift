//
//  GameErrors.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

enum GameErrors: Error, LocalizedError {
    case jsonFileNotFound
    case wordListIsNilOrEmpty
    case currentQestionIsNil
    case gameIsFinished
    case failedToGetRandomElement
    
    var errorDescription: String? {
        switch self {
        case .jsonFileNotFound:
            return "Json file not found"
        case .wordListIsNilOrEmpty:
            return "There is no word to start the game."
        case .currentQestionIsNil:
            return "There is no available question."
        case .gameIsFinished:
            return "The game is finished."
        case .failedToGetRandomElement:
            return "Question list is empty"
        }
    }
}
