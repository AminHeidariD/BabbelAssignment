//
//  IntExtension.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation

extension Int {
    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }
}

