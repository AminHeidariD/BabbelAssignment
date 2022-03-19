//
//  GameViewModelProtocol.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

protocol GameViewModelProtocol {
    init(dataService: DataServiceProtocol, gameSettings: GameSettingsProtocol)
    // MARK: Inputs
    var viewDidLoadSubject: PassthroughSubject<Void, Never> { get }
    var answerActionSubject: PassthroughSubject<AnswerAction, Never> { get }
    // MARK: Outputs
    var timeOutDuration: TimeInterval { get }
    var questionSubject: PassthroughSubject<WordViewModel, Never> { get }
    var userScoreUpdatedSubject: CurrentValueSubject<UserScore, Never> { get }
    var gameFinishedSubject: PassthroughSubject<Void, Never> { get }
    var errorSubject: PassthroughSubject<Error, Never> { get }
    var isLoadingSubject: PassthroughSubject<Bool, Never> { get }
}
