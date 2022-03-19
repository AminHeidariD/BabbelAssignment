//
//  DataServiceProtocol.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getData(url: URL) -> Future<[WordModel]?, Error>
}
