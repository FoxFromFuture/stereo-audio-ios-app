//
//  EndGameViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol EndGameDisplayLogic: AnyObject {
    typealias Model = EndGameModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel)
    func displayPreviousGameScene(_ viewModel: Model.PreviousGame.ViewModel)
}

final class EndGameViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: EndGameBusinessLogic
    private let router: EndGameRoutingLogic
    private let bestScoreLabel = UILabel()
    private let coinsLabel = UILabel()
    private let theEndLabel = UILabel()
    private let scoreLabel = UILabel()
    private let tryAgainButton = UIButton()
    private let mainMenuButton = UIButton()
    private var curLanguage: String?
    private let wallpaper = UIImageView()
    
    // MARK: - LifeCycle
    init(
        router: EndGameRoutingLogic,
        interactor: EndGameBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .black
        configureWallpaper()
        configureBestScoreLabel()
        configureCoinsLabel()
        configureTheEndLabel()
        configureScoreLabel()
        configureTryAgainButton()
        configureMainMenuButton()
    }
    
    private func configureWallpaper() {
        self.view.addSubview(wallpaper)
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.pin(to: self.view, [.bottom: 0, .left: 0, .right: 0, .top: 0])
    }
    
    private func configureBestScoreLabel() {
        self.view.addSubview(bestScoreLabel)
        bestScoreLabel.pinTop(to: self.view.topAnchor, 60)
        bestScoreLabel.pinCenter(to: self.view.centerXAnchor)
        bestScoreLabel.text = "bestScore".localize(lng: self.curLanguage ?? Language.en.str) + ": \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScoreLabel.textColor = .white
        bestScoreLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureCoinsLabel() {
        self.view.addSubview(coinsLabel)
        coinsLabel.pinTop(to: self.view.topAnchor, 100)
        coinsLabel.pinCenter(to: self.view.centerXAnchor)
        coinsLabel.text = "coins".localize(lng: self.curLanguage ?? Language.en.str) + ": \(UserDefaults.standard.integer(forKey: "coins"))" + " (+\(UserDefaults.standard.integer(forKey: "score")))"
        coinsLabel.textColor = .white
        coinsLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureTheEndLabel() {
        self.view.addSubview(theEndLabel)
        theEndLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 182.0)
        theEndLabel.pinCenter(to: self.view.centerXAnchor)
        theEndLabel.text = "theEnd".localize(lng: self.curLanguage ?? Language.en.str)
        theEndLabel.textColor = .white
        theEndLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureScoreLabel() {
        self.view.addSubview(scoreLabel)
        scoreLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 142.0)
        scoreLabel.pinCenter(to: self.view.centerXAnchor)
        scoreLabel.text = "score".localize(lng: self.curLanguage ?? Language.en.str) + ": \(UserDefaults.standard.integer(forKey: "score"))"
        scoreLabel.textColor = .white
        scoreLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureTryAgainButton() {
        self.view.addSubview(tryAgainButton)
        tryAgainButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 49.0)
        tryAgainButton.pinCenter(to: self.view.centerXAnchor)
        tryAgainButton.setTitle("tryAgain".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        tryAgainButton.setTitleColor(.white, for: .normal)
        tryAgainButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonWasTapped), for: .touchDown)
    }
    
    private func configureMainMenuButton() {
        self.view.addSubview(mainMenuButton)
        mainMenuButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 11.0)
        mainMenuButton.pinCenter(to: self.view.centerXAnchor)
        mainMenuButton.setTitle("mainMenu".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        mainMenuButton.setTitleColor(.white, for: .normal)
        mainMenuButton.setTitleColor(.gray, for: .highlighted)
        mainMenuButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        mainMenuButton.addTarget(self, action: #selector(mainMenuButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    private func mainMenuButtonWasTapped() {
        interactor.loadMainMenuScene(Model.MainMenu.Request())
    }
    
    @objc
    private func tryAgainButtonWasTapped() {
        interactor.loadPreviousGameScene(Model.PreviousGame.Request())
    }
}

// MARK: - DisplayLogic
extension EndGameViewController: EndGameDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenuScene()
    }
    
    func displayPreviousGameScene(_ viewModel: Model.PreviousGame.ViewModel) {
        router.routeToPreviousGameScene()
    }
}
