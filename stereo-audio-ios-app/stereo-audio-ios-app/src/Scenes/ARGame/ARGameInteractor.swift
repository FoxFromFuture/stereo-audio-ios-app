//
//  ARGameInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit
import ARKit
import SceneKit

protocol ARGameBusinessLogic {
    typealias Model = ARGameModel
    func loadStart(_ request: Model.Start.Request)
    func loadGame(_ request: Model.Game.Request)
}

final class ARGameInteractor {
    
    // MARK: - Fields
    private let presenter: ARGamePresentationLogic
    private var arSceneView = ARSCNView()
    private var timer: Timer?
    private var audioSource: SCNAudioSource?
    private var duration: CGFloat = 10.0
    private let scene = SCNScene()
    
    // MARK: - LifeCycle
    init(presenter: ARGamePresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Actions
    private func setupAudioEnvironment() {
        let audioEnvironment = self.arSceneView.audioEnvironmentNode
        audioEnvironment.distanceAttenuationParameters.referenceDistance = 0.1
        audioEnvironment.distanceAttenuationParameters.maximumDistance = 15
        audioEnvironment.distanceAttenuationParameters.distanceAttenuationModel = .linear
        audioEnvironment.reverbParameters.enable = true
        audioEnvironment.reverbParameters.loadFactoryReverbPreset(.mediumRoom)
        selectAndSetAudioEnvironmentRenderingAlgorithm()
    }
    
    private func selectAndSetAudioEnvironmentRenderingAlgorithm() {
        let audioSession = AVAudioSession.sharedInstance()
        let outputPortType = audioSession.currentRoute.outputs.first?.portType
        if outputPortType == AVAudioSession.Port.bluetoothA2DP {
            self.arSceneView.audioEnvironmentNode.renderingAlgorithm = .sphericalHead
        } else {
            self.arSceneView.audioEnvironmentNode.renderingAlgorithm = .equalPowerPanning
        }
    }
    
    private func showEnemyModel(path: String, scale: SCNVector3, position: SCNVector3, scene: SCNScene, moveStartPoint: SCNVector3, moveBackAction: SCNAction, rotateAction: SCNAction) {
        let node = SCNNode()
        guard let loadedScene = SCNScene(named: path) else { return }
        loadedScene.rootNode.childNodes.forEach {
            node.addChildNode($0 as SCNNode)
        }
        node.scale = scale
        node.position = position
        node.name = "enemyModel"
        scene.rootNode.addChildNode(node)
        node.addAudioPlayer(SCNAudioPlayer(source: self.audioSource!))
        runModelActions(model: node, moveStartPoint: moveStartPoint, moveBackAction: moveBackAction, rotateAction: rotateAction)
    }
    
    private func runModelActions(model: SCNNode, moveStartPoint: SCNVector3, moveBackAction: SCNAction, rotateAction: SCNAction) {
        let moveUp = SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveUp,moveDown])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        model.runAction(moveLoop)
        model.position = moveStartPoint
        model.runAction(moveBackAction)
        model.runAction(rotateAction)
        self.timer = Timer(timeInterval: 0.01, repeats: true) { _ in
            if model.position ~= SCNVector3(0, 0, 0) {
                self.timer?.invalidate()
                model.removeAllAudioPlayers()
                
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + UserDefaults.standard.integer(forKey: "score"), forKey: "coins")
                if UserDefaults.standard.integer(forKey: "bestScore") < UserDefaults.standard.integer(forKey: "score") {
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "score"), forKey: "bestScore")
                }
                self.presenter.presentEndGameScene(Model.EndGame.Response())
            }
        }
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    private func sideOfTheWorldActions(side: SideOfTheWorld) -> (moveStartPoint: SCNVector3, moveBackAction: SCNAction, rotateAction: SCNAction) {
        switch side {
        case .north:
            let moveStartPoint = SCNVector3(x: 0, y: 0, z: -1.5)
            let moveBackAction = SCNAction.moveBy(x: 0, y: 0, z: 1.5, duration: self.duration)
            let rotateAction = SCNAction.rotate(by: 0, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .northEast:
            let moveStartPoint = SCNVector3(x: 1.5 * sqrt(2), y: 0, z: -1.5 * sqrt(2))
            let moveBackAction = SCNAction.moveBy(x: -1.5 * sqrt(2), y: 0, z: 1.5 * sqrt(2), duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -.pi / 4, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .east:
            let moveStartPoint = SCNVector3(x: 1.5, y: 0, z: 0)
            let moveBackAction = SCNAction.moveBy(x: -1.5, y: 0, z: 0, duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -.pi / 2, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .southEast:
            let moveStartPoint = SCNVector3(x: 1.5 * sqrt(2), y: 0, z: 1.5 * sqrt(2))
            let moveBackAction = SCNAction.moveBy(x: -1.5 * sqrt(2), y: 0, z: -1.5 * sqrt(2), duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -3 * .pi / 4, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .south:
            let moveStartPoint = SCNVector3(x: 0, y: 0, z: 1.5)
            let moveBackAction = SCNAction.moveBy(x: 0, y: 0, z: -1.5, duration: self.duration)
            let rotateAction = SCNAction.rotate(by: 0, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .southWest:
            let moveStartPoint = SCNVector3(x: -1.5 * sqrt(2), y: 0, z: 1.5 * sqrt(2))
            let moveBackAction = SCNAction.moveBy(x: 1.5 * sqrt(2), y: 0, z: -1.5 * sqrt(2), duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -.pi / 4, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .west:
            let moveStartPoint = SCNVector3(x: -1.5, y: 0, z: 0)
            let moveBackAction = SCNAction.moveBy(x: 1.5, y: 0, z: 0, duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -.pi / 2, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        case .northWest:
            let moveStartPoint = SCNVector3(x: -1.5 * sqrt(2), y: 0, z: -1.5 * sqrt(2))
            let moveBackAction = SCNAction.moveBy(x: 1.5 * sqrt(2), y: 0, z: 1.5 * sqrt(2), duration: self.duration)
            let rotateAction = SCNAction.rotate(by: -3 * .pi / 4, around: SCNVector3(0, 1, 0), duration: 0)
            return (moveStartPoint, moveBackAction, rotateAction)
        }
    }
    
    private func touchBeganAction(currentTouchLocation: CGPoint) {
        DispatchQueue.main.async {
            if self.arSceneView.scene.rootNode.childNodes[0].name == "enemyModel" {
                let results = self.arSceneView.hitTest(currentTouchLocation, options: [SCNHitTestOption.rootNode : self.scene.rootNode.childNodes[0]])
                if !results.isEmpty {
                    if self.duration > 3.0 {
                        self.duration -= 0.5
                    }
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "score") + 1, forKey: "score")
                    self.presenter.presentNewScore(Model.NewScore.Response(score: UserDefaults.standard.integer(forKey: "score")))
                    self.arSceneView.scene.rootNode.childNodes[0].removeFromParentNode()
                    let randomSide = SideOfTheWorld.allCases.randomElement()!
                    let actions = self.sideOfTheWorldActions(side: randomSide)
                    self.showEnemyModel(path: "\(UserDefaults.standard.string(forKey: "enemy") ?? "alien")" + ".usdz", scale: SCNVector3(0.07, 0.07, 0.07), position: SCNVector3(0, 0, 0), scene: self.scene, moveStartPoint: actions.moveStartPoint, moveBackAction: actions.moveBackAction, rotateAction: actions.rotateAction)
                }
            } else {
                let results = self.arSceneView.hitTest(currentTouchLocation, options: [SCNHitTestOption.rootNode : self.scene.rootNode.childNodes[2]])
                if !results.isEmpty {
                    if self.duration > 3.0 {
                        self.duration -= 0.5
                    }
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "score") + 1, forKey: "score")
                    self.presenter.presentNewScore(Model.NewScore.Response(score: UserDefaults.standard.integer(forKey: "score")))
                    self.arSceneView.scene.rootNode.childNodes[2].removeFromParentNode()
                    let randomSide = SideOfTheWorld.allCases.randomElement()!
                    let actions = self.sideOfTheWorldActions(side: randomSide)
                    self.showEnemyModel(path: "\(UserDefaults.standard.string(forKey: "enemy") ?? "alien")" + ".usdz", scale: SCNVector3(0.07, 0.07, 0.07), position: SCNVector3(0, 0, 0), scene: self.scene, moveStartPoint: actions.moveStartPoint, moveBackAction: actions.moveBackAction, rotateAction: actions.rotateAction)
                }
            }
        }
    }
}

// MARK: - BusinessLogic
extension ARGameInteractor: ARGameBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        UserDefaults.standard.set(0, forKey: "score")
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadGame(_ request: Model.Game.Request) {
        self.arSceneView = request.arSceneView
        self.arSceneView.rendersMotionBlur = false
        self.setupAudioEnvironment()
        if UserDefaults.standard.string(forKey: "enemy") == "alien" {
            self.audioSource = SCNAudioSource(fileNamed: "alien.mp3")
        } else {
            self.audioSource = SCNAudioSource(fileNamed: "balloon.mp3")
        }
        self.audioSource?.loops = true
        self.audioSource?.load()
        let randomSide = SideOfTheWorld.allCases.randomElement()!
        let actions = sideOfTheWorldActions(side: randomSide)
        showEnemyModel(path: "\(UserDefaults.standard.string(forKey: "enemy") ?? "alien")" + ".usdz", scale: SCNVector3(0.07, 0.07, 0.07), position: SCNVector3(0, 0, 0), scene: scene, moveStartPoint: actions.moveStartPoint, moveBackAction: actions.moveBackAction, rotateAction: actions.rotateAction)
        arSceneView.scene = scene
        arSceneView.automaticallyUpdatesLighting = true
        if self.arSceneView.scene.rootNode.childNodes[0].name == "enemyModel" {
            self.arSceneView.scene.rootNode.childNodes[0].addAudioPlayer(SCNAudioPlayer(source: self.audioSource!))
        }
        presenter.presentGame(Model.Game.Response(action: self.touchBeganAction))
    }
}
