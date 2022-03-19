//
//  GameMenuViewModel.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

class GameMenuViewModel: GameMenuViewModelProtocol {
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: GameMenuViewModelProtocol
    var setupGameSubject = PassthroughSubject<Int, Never>()
    var readyToStartGameSubject = PassthroughSubject<GameSettingsProtocol, Never>()
    
    
    var firstModeValue: Int {
        return 5
    }
    
    var secondModeValue: Int {
        return 10
    }
    
    var thirdModeValue: Int {
        return 20
    }
    
    var firstModeTitle: String {
        return "\(firstModeValue) words"
    }
    
    var secondModeTitle: String {
        return "\(secondModeValue) words"
    }
    
    var thirdModeTitle: String {
        return "\(thirdModeValue) words"
    }
    
    init() {
        setupBindings()
    }
}

// MARK: Methods
private extension GameMenuViewModel {
    func setupBindings() {
        setupGameSubject
            .sink(receiveValue: onSetupGame)
            .store(in: &cancellables)
    }
    
    func onSetupGame(_ wordsCount: Int) {
        let gameSetting = GameSettings(questionCount: wordsCount, timeOutDuration: 5)
        readyToStartGameSubject.send(gameSetting)
    }
}
