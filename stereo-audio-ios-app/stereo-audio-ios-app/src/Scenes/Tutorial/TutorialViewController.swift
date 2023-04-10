//
//  TutorialViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

protocol TutorialDisplayLogic: AnyObject {
    typealias Model = TutorialModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayArTutorImage(_ viewModel: Model.ARTutor.ViewModel)
    func displayOnScreenTutorImage(_ viewModel: Model.OnScreenTutor.ViewModel)
    func displaySoundLicenseWebsite(_ viewModel: Model.SoundLicense.ViewModel)
}

final class TutorialViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: TutorialRoutingLogic
    private let interactor: TutorialBusinessLogic
    private let howToPlayLabel = UILabel()
    private let arButton = UIButton()
    private let onScreenButton = UIButton()
    private let tutorImageView = UIImageView()
    private var curLanguage: String?
    private let soundLicenseButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: TutorialRoutingLogic,
        interactor: TutorialBusinessLogic
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
        view.backgroundColor = UIColor.init(hex: "#2D307E")
        configureHowToPlayLabel()
        configureArButton()
        configureOnScreenButton()
        configureTutorImageView()
        configureSoundLicenseButton()
    }
    
    private func configureHowToPlayLabel() {
        self.view.addSubview(howToPlayLabel)
        howToPlayLabel.pinTop(to: self.view.topAnchor, 50)
        howToPlayLabel.pinCenter(to: self.view.centerXAnchor)
        howToPlayLabel.text = "howToPlay".localize(lng: self.curLanguage ?? Language.en.str)
        howToPlayLabel.textColor = .white
        howToPlayLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureArButton() {
        self.view.addSubview(arButton)
        arButton.pinTop(to: self.view.topAnchor, 110)
        arButton.pin(to: self.view, [.right: 85])
        arButton.setTitle("AR", for: .normal)
        arButton.setTitleColor(.gray, for: .normal)
        arButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        arButton.addTarget(self, action: #selector(arButtonWasTapped), for: .touchDown)
    }
    
    private func configureOnScreenButton() {
        self.view.addSubview(onScreenButton)
        onScreenButton.pinTop(to: self.view.topAnchor, 110)
        onScreenButton.pin(to: self.view, [.left: 65])
        onScreenButton.setTitle("onScreen".localize(lng: self.curLanguage ?? Language.en.str), for: .normal)
        onScreenButton.setTitleColor(.white, for: .normal)
        onScreenButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        onScreenButton.isEnabled = false
        onScreenButton.addTarget(self, action: #selector(onScreenButtonWasTapped), for: .touchDown)
    }
    
    private func configureTutorImageView() {
        self.view.addSubview(tutorImageView)
        tutorImageView.image = UIImage(named: "onScreen-tutor")
        tutorImageView.contentMode = .scaleAspectFill
        tutorImageView.pin(to: self.view, [.bottom: 70, .left: 20, .right: 20, .top: 160])
        tutorImageView.layer.cornerRadius = 5.0
        tutorImageView.layer.masksToBounds = true
    }
    
    private func configureSoundLicenseButton() {
        self.view.addSubview(soundLicenseButton)
        soundLicenseButton.pinCenter(to: self.view.centerXAnchor)
        soundLicenseButton.pinBottom(to: self.view.bottomAnchor, 30)
        soundLicenseButton.setTitle("Sounds by https://quicksounds.com", for: .normal)
        soundLicenseButton.setTitleColor(.gray, for: .normal)
        soundLicenseButton.setTitleColor(.darkGray, for: .highlighted)
        soundLicenseButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        soundLicenseButton.addTarget(self, action: #selector(soundLicenseButtonWasTapped), for: .touchUpInside)
        
    }
    
    // MARK: - Actions
    private func changeButtonStatusToEnabled(button: UIButton) {
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.isEnabled = true
    }
    
    private func changeButtonStatusToDisabled(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.isEnabled = false
    }
    
    @objc
    private func arButtonWasTapped() {
        interactor.loadArTutorImage(Model.ARTutor.Request())
    }
    
    @objc
    private func onScreenButtonWasTapped() {
        interactor.loadOnScreenTutorImage(Model.OnScreenTutor.Request())
    }
    
    @objc
    private func soundLicenseButtonWasTapped() {
        interactor.loadSoundLicenseWebSite(Model.SoundLicense.Request())
    }
}

// MARK: - DisplayLogic
extension TutorialViewController: TutorialDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayArTutorImage(_ viewModel: Model.ARTutor.ViewModel) {
        self.tutorImageView.image = UIImage(named: "ar-tutor")
        self.changeButtonStatusToEnabled(button: onScreenButton)
        self.changeButtonStatusToDisabled(button: arButton)
    }
    
    func displayOnScreenTutorImage(_ viewModel: Model.OnScreenTutor.ViewModel) {
        self.tutorImageView.image = UIImage(named: "onScreen-tutor")
        self.changeButtonStatusToEnabled(button: arButton)
        self.changeButtonStatusToDisabled(button: onScreenButton)
    }
    
    func displaySoundLicenseWebsite(_ viewModel: Model.SoundLicense.ViewModel) {
        router.routeToSoundLicenseWebsite()
    }
}
