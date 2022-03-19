//
//  GameMenuViewModelProtocol.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import Foundation
import Combine

protocol GameMenuViewModelProtocol {
    // MARK: Inputs
    var setupGameSubject: PassthroughSubject<Int, Never> { get }
    // MARK: Outputs
    var readyToStartGameSubject: PassthroughSubject<GameSettingsProtocol, Never> { get }
    var firstModeValue: Int { get }
    var secondModeValue: Int { get }
    var thirdModeValue: Int { get }
    var firstModeTitle: String { get }
    var secondModeTitle: String { get }
    var thirdModeTitle: String { get }
}
