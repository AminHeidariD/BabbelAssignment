//
//  GameViewController.swift
//  BabbelFallingWords
//
//  Created by amin heidari on 3/19/22.
//

import UIKit
import Combine

class GameViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "GameViewController"
    
    // MARK: Outlets
    @IBOutlet private weak var correctCountLabel: UILabel!
    @IBOutlet private weak var wrongCountLabel: UILabel!
    @IBOutlet private weak var notAnsweredCountLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    
    @IBOutlet private weak var wordLabel: UILabel!
    @IBOutlet private weak var translatedWordLabel: UILabel!
    @IBOutlet private weak var translatedWordContainerView: UIView!
    // MARK: Properties
    private let viewModel: GameViewModel
    private var cancellables = Set<AnyCancellable>()
    private var translatedWordAnimator: UIViewPropertyAnimator?
    
    // MARK: Init
    init?(coder: NSCoder, setting: GameSettingsProtocol) {
        viewModel = GameViewModel(dataService: JsonFileDataService(), gameSettings: setting)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a url.")
    }
}

// MARK: Controller Lifecycle
extension GameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoadSubject.send()
    }
}

// MARK: Actions
extension GameViewController {
    @IBAction func correctTouchUpInside(_ sender: UIButton) {
        translatedWordAnimator?.stopAnimation(true)
        viewModel.answerActionSubject.send(.correct)
    }
    
    @IBAction func wrongTouchUpInside(_ sender: UIButton) {
        translatedWordAnimator?.stopAnimation(true)
        viewModel.answerActionSubject.send(.wrong)
    }
}

// MARK: Methods
private extension GameViewController {
    func bindViewModel() {
        viewModel.questionSubject
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: question)
            .store(in: &cancellables)
        //
        //
        viewModel.errorSubject
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: handleError)
            .store(in: &cancellables)
        //
        viewModel.isLoadingSubject
            .receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: handleLoading)
            .store(in: &cancellables)
        //
        viewModel.userScoreUpdatedSubject
            .sink(receiveValue: userScoreUpdated)
            .store(in: &cancellables)
        //
        viewModel.gameFinishedSubject
            .sink(receiveValue: handleGameFinished)
            .store(in: &cancellables)
        
    }
    
    func question(_ wordViewModel: WordViewModel) {
        questionNumberLabel.text = wordViewModel.questionNumberTitle
        wordLabel.text = wordViewModel.wordTitle
        translatedWordLabel.text = wordViewModel.translatedWordTitle
        animateTranslatedWord()
    }
    
    func userScoreUpdated(_ userScore: UserScore) {
        correctCountLabel.text = "\(userScore.correctAnswers)"
        wrongCountLabel.text = "\(userScore.wrongAnswers)"
        notAnsweredCountLabel.text = "\(userScore.notAnswered)"
    }
    
    func handleError(_ error: Error?) {
        // TODO: Hanle errors
        print("Error: \(error?.localizedDescription ?? "")")
    }
    
    func handleLoading(_ isLoading: Bool) {
        // TODO: Hanle show and hide loading and also enable and disable action buttons
    }
    
    func handleGameFinished() {
        clearWordLabels()
        removeBindings()
        showAlert("Congratulations, you completed a great game!!!")
    }
    
    func removeBindings() {
        viewModel.cancellables.removeAll()
        cancellables.removeAll()
    }
    
    func clearWordLabels() {
        wordLabel.text = nil
        translatedWordLabel.text = nil
    }
}

// MARK: UI methods
extension GameViewController {
    func animateTranslatedWord() {
        translatedWordLabel.layer.removeAllAnimations()
        translatedWordLabel.transform = CGAffineTransform.identity
        view.layoutIfNeeded()
        translatedWordAnimator = UIViewPropertyAnimator(duration: viewModel.timeOutDuration, curve: .linear) { [weak self] in
            self?.translatedWordLabel.transform = CGAffineTransform(translationX: 0, y: self?.translatedWordContainerView.frame.height ?? 0)
        }
        
        translatedWordAnimator?.addCompletion { [weak self] completed in
            if (completed != .end) {
                return
            }
            self?.viewModel.answerActionSubject.send(.notAnswered)
        }
        translatedWordAnimator?.startAnimation()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(action)
         present(alert, animated: true)
    }
}
