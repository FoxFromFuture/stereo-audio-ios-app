//
//  ARGamePresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

protocol ARGamePresentationLogic {
    typealias Model = ARGameModel
    func presentStart(_ response: Model.Start.Response)
    func presentGame(_ response: Model.Game.Response)
    func presentNewScore(_ response: Model.NewScore.Response)
    func presentEndGameScene(_ response: Model.EndGame.Response)
}

final class ARGamePresenter {
    // MARK: - Fields
    weak var view: ARGameDisplayLogic?
}

// MARK: - PresentationLogic
extension ARGamePresenter: ARGamePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentGame(_ response: Model.Game.Response) {
        view?.displayGame(Model.Game.ViewModel(action: response.action))
    }
    
    func presentNewScore(_ response: Model.NewScore.Response) {
        view?.displayNewScore(Model.NewScore.ViewModel(score: response.score))
    }
    
    func presentEndGameScene(_ response: Model.EndGame.Response) {
        view?.displayEndGameScene(Model.EndGame.ViewModel())
    }
}
