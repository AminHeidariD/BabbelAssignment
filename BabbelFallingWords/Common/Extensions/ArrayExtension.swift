//
//  ArrayExtension.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

extension Array {
    func getRandomElements(count: Int) -> [Element] {
        var result = [Element]()
        let randomNumbers = Int.getUniqueRandomNumbers(min: 0, max: self.count - 1, count: count)
        
        for i in randomNumbers {
            result.append(self[i])
        }
        
        return result
    }
    
    func getRandomElement() throws -> Element {
        guard let item = self.randomElement() else {
            throw GameErrors.failedToGetRandomElement
        }
        return item
    }
}
