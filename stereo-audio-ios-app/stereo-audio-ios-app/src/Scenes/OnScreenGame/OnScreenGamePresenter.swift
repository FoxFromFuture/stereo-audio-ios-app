//
//  OnScreenGamePresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

protocol OnScreenGamePresentationLogic {
    typealias Model = OnScreenGameModel
    func presentStart(_ response: Model.Start.Response)
    func presentGame(_ response: Model.Game.Response)
    func presentNewScore(_ response: Model.NewScore.Response)
    func presentEndGameScene(_ response: Model.EndGameScene.Response)
}

final class OnScreenGamePresenter {
    // MARK: - Fields
    weak var view: OnScreenGameDisplayLogic?
}

// MARK: - PresentationLogic
extension OnScreenGamePresenter: OnScreenGamePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentGame(_ response: Model.Game.Response) {
        view?.displayGame(Model.Game.ViewModel(pressAction: response.pressAction, touchesBeganAction: response.touchesBeganAction))
    }
    
    func presentNewScore(_ response: Model.NewScore.Response) {
        view?.displayNewScore(Model.NewScore.ViewModel(score: response.score))
    }
    
    func presentEndGameScene(_ response: Model.EndGameScene.Response) {
        view?.displayEndGameScene(Model.EndGameScene.ViewModel())
    }
}
