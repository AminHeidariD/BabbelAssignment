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
    private let jsonFileUrl = Bundle(for: BabbelFallingWordsTests.self).url(forResource: "testWords", withExtension: "json")!
    private var cancellables = Set<AnyCancellable>()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetData() throws {
        let jsonFileUrl = Bundle(for: BabbelFallingWordsTests.self).url(forResource: "testWords", withExtension: "json")!
        let testGetDataExpectation = expectation(description: "Test get data")
        var words: [WordModel]? = nil
        dataService.getData(url: jsonFileUrl).sink(receiveCompletion: { _ in
            testGetDataExpectation.fulfill()
        }, receiveValue: { items in
            words = items
        }).store(in: &cancellables)
        
        wait(for: [testGetDataExpectation], timeout: 2.0)
        XCTAssertEqual(words?.count, 5)
    }
    
    func testFileNotExist() throws {
        let jsonFileUrl = URL(string: "file://NotExist.json")!
        let testFileNotExistExpectation = expectation(description: "testFileNotExist")
        var errorGetData: Error? = nil
        dataService.getData(url: jsonFileUrl).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                errorGetData = error
            case .finished:
                break
            }
            testFileNotExistExpectation.fulfill()
        }, receiveValue: { _ in
            
        }).store(in: &cancellables)
        
        wait(for: [testFileNotExistExpectation], timeout: 2.0)
        XCTAssertNotNil(errorGetData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
