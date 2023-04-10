//
//  StartGameViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol StartGameDisplayLogic: AnyObject {
    typealias Model = StartGameModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel)
    func displayOnScreenGameScene(_ viewModel: Model.OnScreenGame.ViewModel)
    func displayARGameScene(_ viewModel: Model.ARGame.ViewModel)
    func displayCameraAccessAlert(_ viewModel: Model.CameraAccess.ViewModel)
}

final class StartGameViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: StartGameBusinessLogic
    private let router: StartGameRoutingLogic
    private let newGameLabel = UILabel()
    private let arButton = UIButton()
    private let onScreenButton = UIButton()
    private let mainMenuButton = UIButton()
    private var curLanguage: String?
    private let wallpaper = UIImageView()

    // MARK: - LifeCycle
    init(
        router: StartGameRoutingLogic,
        interactor: StartGameBusinessLogic
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
        configureNewGameLabel()
        configureArButton()
        configureOnScreenButton()
        configureMainMenuButton()
    }
    
    private func configureWallpaper() {
        self.view.addSubview(wallpaper)
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.pin(to: self.view, [.bottom: 0, .left: 0, .right: 0, .top: 0])
    }
    
    private func configureNewGameLabel() {
        self.view.addSubview(newGameLabel)
        newGameLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 182.0)
        newGameLabel.pinCenter(to: self.view.centerXAnchor)
        newGameLabel.text = "newGame".localize(lng: self.curLanguage ?? Language.en.str)
        newGameLabel.textColor = .white
        newGameLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureArButton() {
        self.view.addSubview(arButton)
        arButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 49.0)
        arButton.pinCenter(to: self.view.centerXAnchor)
        arButton.setTitle("AR", for: .normal)
        arButton.setTitleColor(.white, for: .normal)
        arButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        arButton.addTarget(self, action: #selector(arButtonWasTapped), for: .touchDown)
    }
    
    private func configureOnScreenButton() {
        self.view.addSubview(onScreenButton)
        onScreenButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 11.0)
        onScreenButton.pinCenter(to: self.view.centerXAnchor)
        onScreenButton.setTitle("onScreen".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        onScreenButton.setTitleColor(.white, for: .normal)
        onScreenButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        onScreenButton.addTarget(self, action: #selector(onScreenButtonWasTapped), for: .touchDown)
    }
    
    private func configureMainMenuButton() {
        self.view.addSubview(mainMenuButton)
        mainMenuButton.pinBottom(to: self.view.bottomAnchor, 60)
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
    private func onScreenButtonWasTapped() {
        interactor.loadOnScreenGameScene(Model.OnScreenGame.Request())
    }
    
    @objc
    private func arButtonWasTapped() {
        interactor.loadARGameScene(Model.ARGame.Request())
    }
}

// MARK: - DisplayLogic
extension StartGameViewController: StartGameDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenuScene()
    }
    
    func displayOnScreenGameScene(_ viewModel: Model.OnScreenGame.ViewModel) {
        router.routeToOnScreenGameScene()
    }
    
    func displayARGameScene(_ viewModel: Model.ARGame.ViewModel) {
        router.routeToARGameScene()
    }
    
    func displayCameraAccessAlert(_ viewModel: Model.CameraAccess.ViewModel) {
        self.present(viewModel.alert, animated: true)
    }
}
