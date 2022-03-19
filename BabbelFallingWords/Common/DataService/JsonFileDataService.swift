//
//  JsonFileDataService.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

final class JsonFileDataService {}

// MARK: DataServiceProtocol
extension JsonFileDataService: DataServiceProtocol {
    func getData(url: URL) -> Future<[WordModel]?, Error> {
        return Future() { promise in
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let words = try decoder.decode([WordModel].self, from: data)
                    promise(Result.success(words))
                } catch {
                    promise(Result.failure(error))
                }
            }
        }
    }
}

