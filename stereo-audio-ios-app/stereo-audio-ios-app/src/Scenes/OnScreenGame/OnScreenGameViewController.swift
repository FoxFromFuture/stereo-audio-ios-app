//
//  OnScreenGameViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit
import AVFoundation

protocol OnScreenGameDisplayLogic: AnyObject {
    typealias Model = OnScreenGameModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayGame(_ viewModel: Model.Game.ViewModel)
    func displayNewScore(_ viewModel: Model.NewScore.ViewModel)
    func displayEndGameScene(_ viewModel: Model.EndGameScene.ViewModel)
}

final class OnScreenGameViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: OnScreenGameBusinessLogic
    private let router: OnScreenGameRoutingLogic
    private let currentScoreLabel = UILabel()
    private var extraView = ExtraView()
    private let userImageView = UIImageView()
    private var shieldButtons = ShieldButton()
    private let sublayer = CALayer()
    private var randomSide: SideOfTheWorld?
    private var curLanguage: String?
    
    // MARK: - LifeCycle
    init(
        router: OnScreenGameRoutingLogic,
        interactor: OnScreenGameBusinessLogic
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.sublayer.frame = CGRect(x: self.shieldButtons.center.x - 30, y: self.shieldButtons.center.y - 30, width: 60, height: 60)
        self.sublayer.contents = UIImage(named: Product.enemy.curProductImageName)?.cgImage
        
        interactor.loadGame(Model.Game.Request(sublayer: self.sublayer, frame: self.view.frame))
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .black
        self.configureExtraView()
        self.view.layer.addSublayer(self.sublayer)
        self.configureShieldButtons()
        self.configureCurrentScoreLabel()
        self.configureUserImageView()
    }
    
    private func configureCurrentScoreLabel() {
        self.view.addSubview(currentScoreLabel)
        currentScoreLabel.pinTop(to: self.view.topAnchor, 60)
        currentScoreLabel.pinCenter(to: self.view.centerXAnchor)
        currentScoreLabel.text = "score".localize(lng: self.curLanguage ?? Language.en.str) + ": 0"
        currentScoreLabel.textColor = .white
        currentScoreLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    private func configureExtraView() {
        self.extraView = ExtraView(frame: self.view.frame)
        self.view.addSubview(self.extraView)
    }
    
    private func configureShieldButtons() {
        self.shieldButtons = ShieldButton(frame: self.view.frame)
        self.view.addSubview(self.shieldButtons)
    }
    
    private func configureUserImageView() {
        self.view.addSubview(userImageView)
        userImageView.pinCenter(to: self.view.centerYAnchor)
        userImageView.pinCenter(to: self.view.centerXAnchor)
        let image = UIImage(systemName: Product.user.curProductImageName, withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 35, weight: .regular)))
        userImageView.image = image
        userImageView.tintColor = .white
        userImageView.backgroundColor = .clear
    }
}

// MARK: - DisplayLogic
extension OnScreenGameViewController: OnScreenGameDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayGame(_ viewModel: Model.Game.ViewModel) {
        shieldButtons.pressAction = viewModel.pressAction
        shieldButtons.touchesBeganAction = viewModel.touchesBeganAction
    }
    
    func displayNewScore(_ viewModel: Model.NewScore.ViewModel) {
        self.currentScoreLabel.text = "score".localize(lng: self.curLanguage ?? Language.en.str) + ": \(viewModel.score)"
    }
    
    func displayEndGameScene(_ viewModel: Model.EndGameScene.ViewModel) {
        router.routeToEndGameScene()
    }
}
