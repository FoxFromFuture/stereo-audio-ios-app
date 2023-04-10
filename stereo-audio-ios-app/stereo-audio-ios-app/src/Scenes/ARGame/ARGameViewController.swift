//
//  ARGameViewController.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit
import ARKit
import SceneKit
import CoreMotion

protocol ARGameDisplayLogic: AnyObject {
    typealias Model = ARGameModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayGame(_ viewModel: Model.Game.ViewModel)
    func displayNewScore(_ viewModel: Model.NewScore.ViewModel)
    func displayEndGameScene(_ viewModel: Model.EndGame.ViewModel)
}

final class ARGameViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: ARGameBusinessLogic
    private let router: ARGameRoutingLogic
    private var arSceneView = ARSCNView()
    private let currentScoreLabel = UILabel()
    private var curLanguage: String?
    private var touchBeganAction: ((CGPoint) -> Void)?
    
    // MARK: - LifeCycle
    init(
        router: ARGameRoutingLogic,
        interactor: ARGameBusinessLogic
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
        super.viewWillAppear(animated)
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.isAutoFocusEnabled = true
        arConfiguration.worldAlignment = .gravityAndHeading
        arSceneView.session.delegate = self
        arSceneView.session.run(arConfiguration)
        interactor.loadGame(Model.Game.Request(arSceneView: self.arSceneView))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arSceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTouchLocation = touches.first?.location(in: self.arSceneView)
        self.touchBeganAction?(currentTouchLocation!)
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = .black
        configureArView()
        self.configureCurrentScoreLabel()
    }
    
    private func configureArView() {
        view.addSubview(arSceneView)
        arSceneView.pin(to: self.view, [.left: 0, .right: 0, .top: 0, .bottom: 0])
        arSceneView.delegate = self
    }
    
    private func configureCurrentScoreLabel() {
        self.view.addSubview(currentScoreLabel)
        currentScoreLabel.pinTop(to: self.view.topAnchor, 60)
        currentScoreLabel.pinCenter(to: self.view.centerXAnchor)
        currentScoreLabel.text = "score".localize(lng: self.curLanguage ?? Language.en.str) + ": 0"
        currentScoreLabel.textColor = .black
        currentScoreLabel.font = .systemFont(ofSize: 24, weight: .regular)
    }
}

// MARK: - DisplayLogic
extension ARGameViewController: ARGameDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.curLanguage = viewModel.lng
        self.configureUI()
    }
    
    func displayGame(_ viewModel: Model.Game.ViewModel) {
        self.touchBeganAction = viewModel.action
    }
    
    func displayNewScore(_ viewModel: Model.NewScore.ViewModel) {
        self.currentScoreLabel.text = "score".localize(lng: self.curLanguage ?? Language.en.str) + ": \(viewModel.score)"
    }
    
    func displayEndGameScene(_ viewModel: Model.EndGame.ViewModel) {
        self.router.routeToEndGameScene()
    }
}
