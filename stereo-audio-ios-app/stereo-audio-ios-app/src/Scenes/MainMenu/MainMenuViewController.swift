//
//  MainMenuViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 28.02.2023.
//

import UIKit

protocol MainMenuDisplayLogic: AnyObject {
    typealias Model = MainMenuModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayNewLanguage(_ viewModel: Model.Language.ViewModel)
    func displayStartGameScene(_ viewModel: Model.StartGame.ViewModel)
    func displayShopScene(_ viewModel: Model.Shop.ViewModel)
    func displayTutorialScene(_ viewModel: Model.Tutorial.ViewModel)
}

final class MainMenuViewController: UIViewController {
    
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: MainMenuBusinessLogic
    private let router: MainMenuRoutingLogic
    private let mainMenuLabel = UILabel()
    public let bestScoreLabel = UILabel()
    private let coinsLabel = UILabel()
    private let startGameButton = UIButton()
    private let shopButton = UIButton()
    private let changeLanguageButton = UIButton()
    private let tutorialButton = UIButton()
    private let wallpaper = UIImageView()
    
    private var curLanguage: String?
    private var otherLanguage: String?
    
    // MARK: - LifeCycle
    init(
        router: MainMenuRoutingLogic,
        interactor: MainMenuBusinessLogic
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
        configureMainMenuLabel()
        configureBestScoreLabel()
        configureCoinsLabel()
        configureStartGameButton()
        configureShopButton()
        configureChangeLanguageButton()
        configureTutorialButton()
    }
    
    private func configureWallpaper() {
        self.view.addSubview(wallpaper)
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.pin(to: self.view, [.bottom: 0, .left: 0, .right: 0, .top: 0])
    }
    
    private func configureMainMenuLabel() {
        self.view.addSubview(mainMenuLabel)
        mainMenuLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 182.0)
        mainMenuLabel.pinCenter(to: self.view.centerXAnchor)
        mainMenuLabel.text = "mainMenu".localize(lng: self.curLanguage ?? Language.en.str)
        mainMenuLabel.textColor = .white
        mainMenuLabel.font = .systemFont(ofSize: 32, weight: .regular)
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
        coinsLabel.text = "coins".localize(lng: self.curLanguage ?? Language.en.str) + ": \(UserDefaults.standard.integer(forKey: "coins"))"
        coinsLabel.textColor = .white
        coinsLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureStartGameButton() {
        self.view.addSubview(startGameButton)
        startGameButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 49.0)
        startGameButton.pinCenter(to: self.view.centerXAnchor)
        startGameButton.setTitle("startGame".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.setTitleColor(.gray, for: .highlighted)
        startGameButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        startGameButton.setTitleShadowColor(.black, for: .normal)
        startGameButton.addTarget(self, action: #selector(startGameButtonWasTapped), for: .touchDown)
    }
    
    private func configureShopButton() {
        self.view.addSubview(shopButton)
        shopButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 11.0)
        shopButton.pinCenter(to: self.view.centerXAnchor)
        shopButton.setTitle("shop".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        shopButton.setTitleColor(.white, for: .normal)
        shopButton.setTitleColor(.gray, for: .highlighted)
        shopButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        shopButton.addTarget(self, action: #selector(shopButtonWasTapped), for: .touchDown)
    }
    
    private func configureChangeLanguageButton() {
        self.view.addSubview(changeLanguageButton)
        changeLanguageButton.pinBottom(to: self.view.bottomAnchor, 40)
        changeLanguageButton.pin(to: self.view, [.right: 16, .left: 294])
        changeLanguageButton.setTitleColor(.white, for: .normal)
        changeLanguageButton.setTitleColor(.gray, for: .highlighted)
        changeLanguageButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        changeLanguageButton.menu = UIMenu(children: [
            UIAction(title: self.curLanguage?.uppercased() ?? Language.en.str.uppercased(), state: .on, handler: { action in
                let newLanguange = self.curLanguage ?? Language.en.str
                self.interactor.loadNewLanguage(Model.Language.Request(lng: newLanguange))
            }),
            UIAction(title: self.otherLanguage?.uppercased() ?? Language.ru.str.uppercased(), handler: { action in
                let newLanguange = self.otherLanguage ?? Language.ru.str
                self.interactor.loadNewLanguage(Model.Language.Request(lng: newLanguange))
            }),
        ])
        changeLanguageButton.showsMenuAsPrimaryAction = true
        changeLanguageButton.changesSelectionAsPrimaryAction = true
    }
    
    private func configureTutorialButton() {
        self.view.addSubview(tutorialButton)
        tutorialButton.pinBottom(to: self.view.bottomAnchor, 44)
        tutorialButton.pin(to: self.view, [.left: 16, .right: 294])
        let image = UIImage(systemName: "questionmark.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        tutorialButton.setImage(image, for: .normal)
        tutorialButton.tintColor = .white
        tutorialButton.backgroundColor = .clear
        tutorialButton.addTarget(self, action: #selector(tutorialButtonWasTapped), for: .touchDown)
    }
    
    // MARK: - Actions
    @objc
    private func startGameButtonWasTapped() {
        interactor.loadStartGameScene(Model.StartGame.Request())
    }
    
    @objc
    private func shopButtonWasTapped() {
        interactor.loadShopScene(Model.Shop.Request())
    }
    
    @objc
    private func tutorialButtonWasTapped() {
        interactor.loadTutorialScene(Model.Tutorial.Request())
    }
}

// MARK: - DisplayLogic
extension MainMenuViewController: MainMenuDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.otherLanguage = viewModel.otherLng
        self.configureUI()
    }
    
    func displayNewLanguage(_ viewModel: Model.Language.ViewModel) {
        let lng = viewModel.lng
        self.mainMenuLabel.text = "mainMenu".localize(lng: lng)
        self.startGameButton.setTitle("startGame".localize(lng: lng), for: .normal)
        self.shopButton.setTitle("shop".localize(lng: lng), for: .normal)
        self.bestScoreLabel.text = "bestScore".localize(lng: lng) + ": \(UserDefaults.standard.integer(forKey: "bestScore"))"
        self.coinsLabel.text = "coins".localize(lng: lng) + ": \(UserDefaults.standard.integer(forKey: "coins"))"
    }
    
    func displayStartGameScene(_ viewModel: Model.StartGame.ViewModel) {
        router.routeToStartGameScene()
    }
    
    func displayShopScene(_ viewModel: Model.Shop.ViewModel) {
        router.routeToShopScene()
    }
    
    func displayTutorialScene(_ viewModel: Model.Tutorial.ViewModel) {
        router.routeToTutorialScene()
    }
}
