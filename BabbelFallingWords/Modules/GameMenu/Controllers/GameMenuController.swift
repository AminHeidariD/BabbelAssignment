//
//  GameMenuController.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import UIKit
import Combine

class GameMenuController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var thirdButton: UIButton!
    
    // MARK: Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = GameMenuViewModel()
}

// MARK: Controller Lifecycle
extension GameMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: Actions
extension GameMenuController {
    @IBAction func firstButtonTouchUpInside(_ sender: UIButton) {
        viewModel.setupGameSubject.send(viewModel.firstModeValue)
    }
    
    @IBAction func secondButtonTouchUpInside(_ sender: UIButton) {
        viewModel.setupGameSubject.send(viewModel.secondModeValue)
    }
    
    @IBAction func thirdButtonTouchUpInside(_ sender: UIButton) {
        viewModel.setupGameSubject.send(viewModel.thirdModeValue)
    }
}

// MARK: Methods
extension GameMenuController {
    func setupBindings() {
        viewModel.readyToStartGameSubject
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: startTheGame)
            .store(in: &cancellables)
        //
        firstButton.setTitle(viewModel.firstModeTitle, for: .normal)
        secondButton.setTitle(viewModel.secondModeTitle, for: .normal)
        thirdButton.setTitle(viewModel.thirdModeTitle, for: .normal)
    }
    
    func startTheGame(_ setting: GameSettingsProtocol) {
        presentGame(setting)
    }
    
    func presentGame(_ setting: GameSettingsProtocol) {
        let gameViewController = initiateDetailViewController(with: setting)
        present(gameViewController, animated: true)
    }
    
    func initiateDetailViewController(with setting: GameSettingsProtocol) -> GameViewController {
        let mainStroyboard = UIStoryboard(name: "Game", bundle: nil)
        return mainStroyboard.instantiateViewController(identifier: GameViewController.identifier) { coder in
                   return GameViewController(coder: coder, setting: setting)
        }
    }
}
