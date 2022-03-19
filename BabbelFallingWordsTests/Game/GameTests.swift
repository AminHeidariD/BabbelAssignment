//
//  GameTests.swift
//  BabbelFallingWordsTests
//
//  Created by amin heidari on 3/19/22.
//

import XCTest
import Combine
@testable import BabbelFallingWords

class GameTests: XCTestCase {

    private let dataService: DataServiceProtocol = JsonFileDataService()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: GameViewModelProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = GameViewModel(dataService: JsonFileDataService(), gameSettings: GameSettings(questionCount: 5))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func testLoading() {
        let expectation = self.expectation(description: "testLoading")
        var loadingStates: [Bool] = []
        viewModel?.isLoadingSubject
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        //
        viewModel?.viewDidLoadSubject.send()
        //
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    func testFinishGame() {
        let questionCount = 3
        viewModel = GameViewModel(dataService: JsonFileDataService(), gameSettings: GameSettings(questionCount: questionCount))
        let expectation = self.expectation(description: "testFinishGame")
        var isGameFinished = false
        viewModel?.isLoadingSubject
            .sink { isLoading in
                if !isLoading {
                    (0..<questionCount).forEach({ _ in
                        // Repeat answer questions
                        self.viewModel?.answerActionSubject.send(.correct)
                    })
                }
            }.store(in: &cancellables)
        
        viewModel?.gameFinishedSubject
            .sink {
                isGameFinished = true
                expectation.fulfill()
            }.store(in: &cancellables)
        //
        viewModel?.viewDidLoadSubject.send()
        //
        wait(for: [expectation], timeout: 2.0)
        //
        XCTAssertTrue(isGameFinished)
    }
    
    func testErroOnActionBeforeLoadData() {
        let questionCount = 1
        viewModel = GameViewModel(dataService: JsonFileDataService(), gameSettings: GameSettings(questionCount: questionCount))
        let expectation = self.expectation(description: "testErroOnAction")
        var error: GameErrors?
        viewModel?.errorSubject
            .sink { err in
                error = err as? GameErrors
                expectation.fulfill()
            }.store(in: &cancellables)
        //
        self.viewModel?.answerActionSubject.send(.correct)
        //
        wait(for: [expectation], timeout: 2.0)
        //
        XCTAssertNotNil(error)
        // TODO: Handle this test with better error(game is not started or words is not loaded)
        XCTAssertEqual(error, GameErrors.currentQestionIsNil)
    }
    
    func testUserscore() {
        let questionCount = 1
        viewModel = GameViewModel(dataService: JsonFileDataService(), gameSettings: GameSettings(questionCount: questionCount))
        let expectation = self.expectation(description: "testUserscore")
        viewModel?.isLoadingSubject
            .sink { isLoading in
                if !isLoading {
                    self.viewModel?.answerActionSubject.send(.correct)
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        //
        viewModel?.viewDidLoadSubject.send()
        //
        wait(for: [expectation], timeout: 2.0)
        //
        let userScore = viewModel?.userScoreUpdatedSubject.value
        //
        XCTAssertNotNil(userScore)
        XCTAssertEqual(userScore?.correctAnswers ?? 0, 1)
        XCTAssertEqual(userScore?.wrongAnswers ?? 0, 0)
        XCTAssertEqual(userScore?.notAnswered ?? 0, 0)
    }
}
