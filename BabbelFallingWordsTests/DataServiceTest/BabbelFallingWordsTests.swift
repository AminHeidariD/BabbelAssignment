//
//  BabbelFallingWordsTests.swift
//  BabbelFallingWordsTests
//
//  Created by amin heidari on 3/19/22.
//

import XCTest
import Combine
@testable import BabbelFallingWords

class BabbelFallingWordsTests: XCTestCase {

    private let dataService: DataServiceProtocol = JsonFileDataService()
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables.removeAll()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetData() throws {
        let jsonFileUrl = Bundle(for: BabbelFallingWordsTests.self).url(forResource: "words", withExtension: "json")!
        let expectation = expectation(description: "Test get data")
        var words: [WordModel]? = nil
        dataService.getData(url: jsonFileUrl).sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { items in
            words = items
        }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        //
        XCTAssertEqual(words?.count, 5)
    }
    
    func testFileNotExist() throws {
        let jsonFileUrl = URL(string: "file://NotExist.json")!
        let expectation = expectation(description: "testFileNotExist")
        var errorGetData: Error? = nil
        dataService.getData(url: jsonFileUrl).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                errorGetData = error
            case .finished:
                break
            }
            expectation.fulfill()
        }, receiveValue: { _ in})
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        //
        XCTAssertNotNil(errorGetData)
    }
}
