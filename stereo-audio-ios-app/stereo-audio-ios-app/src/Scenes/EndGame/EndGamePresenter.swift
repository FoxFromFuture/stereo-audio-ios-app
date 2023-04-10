//
//  EndGamePresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol EndGamePresentationLogic {
    typealias Model = EndGameModel
    func presentStart(_ response: Model.Start.Response)
    func presentMainMenuScene(_ response: Model.MainMenu.Response)
    func presentPreviousGameScene(_ response: Model.PreviousGame.Response)
}

final class EndGamePresenter {
    // MARK: - Fields
    weak var view: EndGameDisplayLogic?
}

// MARK: - PresentationLogic
extension EndGamePresenter: EndGamePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentMainMenuScene(_ response: Model.MainMenu.Response) {
        view?.displayMainMenuScene(Model.MainMenu.ViewModel())
    }
    
    func presentPreviousGameScene(_ response: Model.PreviousGame.Response) {
        view?.displayPreviousGameScene(Model.PreviousGame.ViewModel())
    }
}
