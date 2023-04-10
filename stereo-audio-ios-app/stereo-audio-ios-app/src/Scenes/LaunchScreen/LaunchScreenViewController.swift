//
//  LaunchScreenViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit

protocol LaunchScreenDisplayLogic: AnyObject {
    typealias Model = LaunchScreenModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel)
}

final class LaunchScreenViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: LaunchScreenBusinessLogic
    private let router: LaunchScreenRoutingLogic
    private let appNameLabel = UILabel()
    private let bottomLabel = UILabel()
    private let tutorLabel = UILabel()
    private let tutorImageView = UIImageView()
    private let soundLicenseLabel = UILabel()
    private let wallpaper = UIImageView()
    
    // MARK: - LifeCycle
    init(
        router: LaunchScreenRoutingLogic,
        interactor: LaunchScreenBusinessLogic
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
        interactor.loadUserDefaults()
        interactor.loadStart(Model.Start.Request())
        interactor.loadMainMenuScene(Model.MainMenu.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        configureWallpaper()
        configureAppNameLabel()
        configureBottomLabel()
        configureTutorLabel()
        configureTutorImageView()
        configureSoundLicenseLabel()
    }
    
    private func configureWallpaper() {
        self.view.addSubview(wallpaper)
        wallpaper.image = UIImage(named: "wallpaper")
        wallpaper.contentMode = .scaleAspectFill
        wallpaper.pin(to: self.view, [.bottom: 0, .left: 0, .right: 0, .top: 0])
    }
    
    private func configureAppNameLabel() {
        self.view.addSubview(appNameLabel)
        appNameLabel.pinCenter(to: self.view.centerXAnchor)
        appNameLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 182.0)
        appNameLabel.text = "BEAT THE ALIEN"
        appNameLabel.textColor = .white
        appNameLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureBottomLabel() {
        self.view.addSubview(bottomLabel)
        bottomLabel.pinCenter(to: self.view.centerXAnchor)
        bottomLabel.pinBottom(to: self.view.bottomAnchor, 34)
        bottomLabel.text = "Spatial Audio Game"
        bottomLabel.textColor = .white
        bottomLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureTutorLabel() {
        self.view.addSubview(tutorLabel)
        tutorLabel.pinCenter(to: self.view.centerXAnchor)
        tutorLabel.pinCenter(to: self.view.centerYAnchor)
        tutorLabel.text = "launchScreenHeadset".localize(lng: UserDefaults.standard.string(forKey: "lng")!)
        tutorLabel.textColor = .white
        tutorLabel.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func configureTutorImageView() {
        self.view.addSubview(tutorImageView)
        tutorImageView.pinCenter(to: self.view.centerXAnchor)
        tutorImageView.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 28.0)
        tutorImageView.image = UIImage(systemName: "headphones", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        tutorImageView.tintColor = .white
        tutorImageView.backgroundColor = .clear
    }
    
    private func configureSoundLicenseLabel() {
        self.view.addSubview(soundLicenseLabel)
        soundLicenseLabel.pinCenter(to: self.view.centerXAnchor)
        soundLicenseLabel.pinBottom(to: self.view.bottomAnchor, 74)
        soundLicenseLabel.text = "Sounds by https://quicksounds.com"
        soundLicenseLabel.textColor = .gray
        soundLicenseLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
}

// MARK: - DisplayLogic
extension LaunchScreenViewController: LaunchScreenDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayMainMenuScene(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenuViewController()
    }
}
