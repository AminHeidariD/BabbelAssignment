//
//  WordViewModel.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

class GameViewModel: GameViewModelProtocol {
    
    // MARK: Dependencies
    private let dataService: DataServiceProtocol
    private let gameSettings: GameSettingsProtocol
    
    // MARK: Properties
    private var questionsDatasource: [WordViewModel]?
    private var currentQuestion: WordViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var isGameFinished: Bool {
        return questionsDatasource?.isEmpty ?? true
    }
    
    // MARK: GameViewModelProtocol
    // Inputs
    var viewDidLoadSubject = PassthroughSubject<Void, Never>()
    var answerActionSubject = PassthroughSubject<AnswerAction, Never>()
    // Outputs
    var questionSubject = PassthroughSubject<WordViewModel, Never>()
    var userScoreUpdatedSubject = CurrentValueSubject<UserScore, Never>(UserScore())
    var gameFinishedSubject = PassthroughSubject<Void, Never>()
    var errorSubject = PassthroughSubject<Error, Never>()
    var isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: Init
    required init(dataService: DataServiceProtocol, gameSettings: GameSettingsProtocol) {
        self.dataService = dataService
        self.gameSettings = gameSettings
        setupBindings()
    }
}

// MARK: Methods
private extension GameViewModel {
    func setupBindings() {
        viewDidLoadSubject
            .sink(receiveValue: getData)
            .store(in: &cancellables)
        //
        answerActionSubject
            .sink(receiveValue: onRecieveAction)
            .store(in: &cancellables)
    }
    
    func getData() {
        // TODO: Pass this url as a dependency
        guard let fileUrl = Bundle.main.url(forResource: "words", withExtension: "json") else {
            errorSubject.send(GameErrors.jsonFileNotFound)
            return
        }
        //
        isLoadingSubject.send(true)
        //
        dataService.getData(url: fileUrl)
            .sink(receiveCompletion: onReceiveCompletion, receiveValue: onReceiveWords)
            .store(in: &cancellables)
    }
    
    func onRecieveAction(_ action: AnswerAction) {
        updateScore(action)
        //
        if isGameFinished {
            gameFinishedSubject.send()
        } else {
            popQuestion()
        }
    }
    
    func onReceiveWords(_ words: [WordModel]? ) {
        guard let words = words, !words.isEmpty else {
            errorSubject.send(GameErrors.wordListIsNilOrEmpty)
            return
        }
        //
        gameSettings.setTotalWords(n: words.count)
        // Make questions
        do {
            questionsDatasource = try makeQuestions(words: words, count: gameSettings.questionCount)
        } catch {
            errorSubject.send(error)
        }
        //
        popQuestion()
    }
    
    func onReceiveCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoadingSubject.send(false)
        //
        switch completion {
        case .failure(let error):
            errorSubject.send(error)
        case .finished:
            break
        }
    }
    
    func popQuestion() {
        defer {
            if !(questionsDatasource?.isEmpty ?? true) {
                questionsDatasource?.removeFirst()
            }
        }
        //
        guard let currentQuestion = questionsDatasource?.first, !isGameFinished else {
            errorSubject.send(GameErrors.gameIsFinished)
            return
        }
        //
        self.currentQuestion = currentQuestion
        questionSubject.send(currentQuestion)
    }
    
    func updateScore(_ action: AnswerAction) {
        guard let currentQuestion = currentQuestion else {
            errorSubject.send(GameErrors.currentQestionIsNil)
            return
        }
        //
        switch currentQuestion.checkAnswer(with: action) {
        case .correct:
            userScoreUpdatedSubject.value.AddCorrectAnswer()
        case .wrong:
            userScoreUpdatedSubject.value.AddWrongAnswer()
        case .notAnswered:
            userScoreUpdatedSubject.value.addNotAnswered()
        }
        //
        userScoreUpdatedSubject.send(userScoreUpdatedSubject.value)
    }
    
    func makeQuestions(words: [WordModel], count: Int) throws -> [WordViewModel] {
        let randomWords = words.getRandomElements(count: count)
        
        var questions = [WordViewModel]()
        for (index, word) in randomWords.enumerated() {
            let randomAnswer = try randomWords.getRandomElement()
            let isTranslatedWordCorrect = word == randomAnswer
            let wordViewModel = WordViewModel(word: word, isTranslatedWordCorrect: isTranslatedWordCorrect, questionNumber: index + 1, totalQuestionNumber: gameSettings.questionCount)
            questions.append(wordViewModel)
        }
        
        return questions
    }
}

