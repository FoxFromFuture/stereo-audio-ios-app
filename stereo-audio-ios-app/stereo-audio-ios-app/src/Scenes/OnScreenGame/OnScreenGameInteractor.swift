//
//  OnScreenGameInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit
import AVFoundation

protocol OnScreenGameBusinessLogic {
    typealias Model = OnScreenGameModel
    func loadStart(_ request: Model.Start.Request)
    func loadGame(_ request: Model.Game.Request)
}

final class OnScreenGameInteractor {
    
    // MARK: - Fields
    private var timer: Timer?
    private var duration: CGFloat = 10.0
    private var audioSource: AudioSource?
    private var files: [AudioFile] = [.alien, .balloon]
    private var curSublayerAnimationPosition = CGPoint()
    private let presenter: OnScreenGamePresentationLogic
    private var randomSide: SideOfTheWorld = .north
    private var sublayer = CALayer()
    private var frame = CGRect()
    private var curScore = 0
    
    private let engine = AVAudioEngine()
    private let environment = AVAudioEnvironmentNode()
    
    // MARK: - LifeCycle
    init(presenter: OnScreenGamePresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Actions
    private func sideOfTheWorldSublayerPosition(side: SideOfTheWorld) -> (sublayerPositionStart: CGPoint, sublayerPositionEnd: CGPoint) {
        switch side {
        case .north:
            let positionStart = CGPoint(x: (frame.width / 2.0), y: (frame.height / 2.0) - 500)
            let positionEnd = CGPoint(x: (frame.width / 2.0), y: (frame.height / 2.0) - 10)
            return (positionStart, positionEnd)
        case .northEast:
            let positionStart = CGPoint(x: (frame.width / 2.0) + (500 / sqrt(2)), y: (frame.height / 2.0) - (500 / sqrt(2)))
            let positionEnd = CGPoint(x: (frame.width / 2.0) + (10 / sqrt(2)), y: (frame.height / 2.0) - (10 / sqrt(2)))
            return (positionStart, positionEnd)
        case .east:
            let positionStart = CGPoint(x: (frame.width / 2.0) + 500, y: (frame.height / 2.0))
            let positionEnd = CGPoint(x: (frame.width / 2.0) + 10, y: (frame.height / 2.0))
            return (positionStart, positionEnd)
        case .southEast:
            let positionStart = CGPoint(x: (frame.width / 2.0) + (500 / sqrt(2)), y: (frame.height / 2.0) + (500 / sqrt(2)))
            let positionEnd = CGPoint(x: (frame.width / 2.0) + (10 / sqrt(2)), y: (frame.height / 2.0) + (10 / sqrt(2)))
            return (positionStart, positionEnd)
        case .south:
            let positionStart = CGPoint(x: (frame.width / 2.0), y: (frame.height / 2.0) + 500)
            let positionEnd = CGPoint(x: (frame.width / 2.0), y: (frame.height / 2.0) + 10)
            return (positionStart, positionEnd)
        case .southWest:
            let positionStart = CGPoint(x: (frame.width / 2.0) - (500 / sqrt(2)), y: (frame.height / 2.0) + (500 / sqrt(2)))
            let positionEnd = CGPoint(x: (frame.width / 2.0) - (10 / sqrt(2)), y: (frame.height / 2.0) + (10 / sqrt(2)))
            return (positionStart, positionEnd)
        case .west:
            let positionStart = CGPoint(x: (frame.width / 2.0) - 500, y: (frame.height / 2.0))
            let positionEnd = CGPoint(x: (frame.width / 2.0) - 10, y: (frame.height / 2.0))
            return (positionStart, positionEnd)
        case .northWest:
            let positionStart = CGPoint(x: (frame.width / 2.0) - (500 / sqrt(2)), y: (frame.height / 2.0) - (500 / sqrt(2)))
            let positionEnd = CGPoint(x: (frame.width / 2.0) - (10 / sqrt(2)), y: (frame.height / 2.0) - (10 / sqrt(2)))
            return (positionStart, positionEnd)
        }
    }
    
    private func sideOfTheWorldAudioSourcePosition(side: SideOfTheWorld) -> (audioSourcePositionStart: CGPoint, audioSourcePositionEnd: CGPoint) {
        switch side {
        case .north:
            let positionStart = CGPoint(x: 0, y: -frame.width / 2.0)
            let positionEnd = CGPoint(x: 0, y: -10)
            return (positionStart, positionEnd)
        case .northEast:
            let positionStart = CGPoint(x: frame.width / (2.0 * sqrt(2)), y: -frame.width / (2.0 * sqrt(2)))
            let positionEnd = CGPoint(x: 10 / sqrt(2), y: -10 / sqrt(2))
            return (positionStart, positionEnd)
        case .east:
            let positionStart = CGPoint(x: frame.width / 2.0, y: 0)
            let positionEnd = CGPoint(x: 10, y: 0)
            return (positionStart, positionEnd)
        case .southEast:
            let positionStart = CGPoint(x: frame.width / (2.0 * sqrt(2)), y: frame.width / (2.0 * sqrt(2)))
            let positionEnd = CGPoint(x: 10 / sqrt(2), y: 10 / sqrt(2))
            return (positionStart, positionEnd)
        case .south:
            let positionStart = CGPoint(x: 0, y: frame.width / 2.0)
            let positionEnd = CGPoint(x: 0, y: 10)
            return (positionStart, positionEnd)
        case .southWest:
            let positionStart = CGPoint(x: -frame.width / (2.0 * sqrt(2)), y: frame.width / (2.0 * sqrt(2)))
            let positionEnd = CGPoint(x: -10 / sqrt(2), y: 10 / sqrt(2))
            return (positionStart, positionEnd)
        case .west:
            let positionStart = CGPoint(x: -frame.width / 2.0, y: 0)
            let positionEnd = CGPoint(x: -10, y: 0)
            return (positionStart, positionEnd)
        case .northWest:
            let positionStart = CGPoint(x: -frame.width / (2.0 * sqrt(2)), y: -frame.width / (2.0 * sqrt(2)))
            let positionEnd = CGPoint(x: -10 / sqrt(2), y: -10 / sqrt(2))
            return (positionStart, positionEnd)
        }
    }
    
    private func audioSourceMotion(sideOfTheWorld: SideOfTheWorld) {
        let audioSourcePositionStart = sideOfTheWorldAudioSourcePosition(side: sideOfTheWorld).audioSourcePositionStart
        let audioSourcePositionEnd = sideOfTheWorldAudioSourcePosition(side: sideOfTheWorld).audioSourcePositionEnd
        if UserDefaults.standard.string(forKey: "enemy") == "alien" {
            audioSource = AudioSource(
                audio: self.files[0],
                startPoint: CGPoint(
                    x: audioSourcePositionStart.x,
                    y: audioSourcePositionStart.y
                )
            )
        } else {
            audioSource = AudioSource(
                audio: self.files[1],
                startPoint: CGPoint(
                    x: audioSourcePositionStart.x,
                    y: audioSourcePositionStart.y
                )
            )
        }
        
        let sublayerPositionStart = sideOfTheWorldSublayerPosition(side: sideOfTheWorld).sublayerPositionStart
        let sublayerPositionEnd = sideOfTheWorldSublayerPosition(side: sideOfTheWorld).sublayerPositionEnd
        let positionMotion = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        self.curSublayerAnimationPosition = audioSourcePositionStart
        positionMotion.fromValue = sublayerPositionStart
        positionMotion.toValue = sublayerPositionEnd
        positionMotion.duration = self.duration
        positionMotion.autoreverses = false
        
        let speed = (sqrt(pow(audioSourcePositionStart.x - audioSourcePositionEnd.x, 2) + pow(audioSourcePositionStart.y - audioSourcePositionEnd.y, 2))) / (self.duration)
        
        CATransaction.begin()
        sublayer.add(positionMotion, forKey: #keyPath(CALayer.position))
        self.timer = Timer(timeInterval: 0.21, repeats: true) { _ in
            if sqrt(pow(self.curSublayerAnimationPosition.x, 2) + pow(self.curSublayerAnimationPosition.y, 2)) > 10.0  {
                if sideOfTheWorld == SideOfTheWorld.north {
                    self.curSublayerAnimationPosition.y += speed / 4
                }
                if sideOfTheWorld == SideOfTheWorld.northEast {
                    self.curSublayerAnimationPosition.y += speed / (sqrt(2) * 4)
                    self.curSublayerAnimationPosition.x -= speed / (sqrt(2) * 4)
                }
                if sideOfTheWorld == SideOfTheWorld.east {
                    self.curSublayerAnimationPosition.x -= speed / 4
                }
                if sideOfTheWorld == SideOfTheWorld.southEast {
                    self.curSublayerAnimationPosition.y -= speed / (sqrt(2) * 4)
                    self.curSublayerAnimationPosition.x -= speed / (sqrt(2) * 4)
                }
                if sideOfTheWorld == SideOfTheWorld.south {
                    self.curSublayerAnimationPosition.y -= speed / 4
                }
                if sideOfTheWorld == SideOfTheWorld.southWest {
                    self.curSublayerAnimationPosition.y -= speed / (sqrt(2) * 4)
                    self.curSublayerAnimationPosition.x += speed / (sqrt(2) * 4)
                }
                if sideOfTheWorld == SideOfTheWorld.west {
                    self.curSublayerAnimationPosition.x += speed / 4
                }
                if sideOfTheWorld == SideOfTheWorld.northWest {
                    self.curSublayerAnimationPosition.y += speed / (sqrt(2) * 4)
                    self.curSublayerAnimationPosition.x += speed / (sqrt(2) * 4)
                }
                self.audioSource?.updatePosition(newPoint: self.curSublayerAnimationPosition)
            } else {
                self.timer?.invalidate()
                self.audioSource?.stopAudio()
                print("stopped")
                UserDefaults.standard.set(self.curScore, forKey: "score")
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + self.curScore, forKey: "coins")
                if UserDefaults.standard.integer(forKey: "bestScore") < self.curScore {
                    UserDefaults.standard.set(self.curScore, forKey: "bestScore")
                }
                self.curScore = 0
                self.presenter.presentEndGameScene(Model.EndGameScene.Response())
            }
        }
        RunLoop.current.add(self.timer!, forMode: .common)
        CATransaction.commit()
    }
    
    private func pressAction(i: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if SideOfTheWorld.allCases[i] == self.randomSide {
            self.timer?.invalidate()
            self.audioSource?.stopAudio()
            self.randomSide = SideOfTheWorld.allCases.randomElement()!
            self.audioSourceMotion(sideOfTheWorld: self.randomSide)
            self.curScore += 1
            if self.duration > 2.5 {
                self.duration -= 0.5
            }
            self.presenter.presentNewScore(Model.NewScore.Response(score: self.curScore))
        } else {
            self.timer?.invalidate()
            self.audioSource?.stopAudio()
            UserDefaults.standard.set(self.curScore, forKey: "score")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "coins") + self.curScore, forKey: "coins")
            if UserDefaults.standard.integer(forKey: "bestScore") < self.curScore {
                UserDefaults.standard.set(self.curScore, forKey: "bestScore")
            }
            self.curScore = 0
            self.presenter.presentEndGameScene(Model.EndGameScene.Response())
        }
    }
    
    private func touchesBeganAction(i: Int) -> CGColor {
        if SideOfTheWorld.allCases[i] == self.randomSide {
            return UIColor.green.cgColor
        } else {
            return UIColor.red.cgColor
        }
    }
}

// MARK: - BusinessLogic
extension OnScreenGameInteractor: OnScreenGameBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        UserDefaults.standard.set(0, forKey: "score")
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadGame(_ request: Model.Game.Request) {
        self.randomSide = SideOfTheWorld.allCases.randomElement()!
        self.sublayer = request.sublayer
        self.frame = request.frame
        presenter.presentGame(Model.Game.Response(pressAction: self.pressAction, touchesBeganAction: self.touchesBeganAction))
        self.audioSourceMotion(sideOfTheWorld: randomSide)
    }
}
