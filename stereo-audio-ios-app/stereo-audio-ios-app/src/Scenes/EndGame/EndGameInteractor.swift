//
//  EndGameInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol EndGameBusinessLogic {
    typealias Model = EndGameModel
    func loadStart(_ request: Model.Start.Request)
    func loadMainMenuScene(_ request: Model.MainMenu.Request)
    func loadPreviousGameScene(_ request: Model.PreviousGame.Request)
}

final class EndGameInteractor {    
    // MARK: - Fields
    private let presenter: EndGamePresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: EndGamePresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension EndGameInteractor: EndGameBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadMainMenuScene(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenuScene(Model.MainMenu.Response())
    }
    
    func loadPreviousGameScene(_ request: Model.PreviousGame.Request) {
        presenter.presentPreviousGameScene(Model.PreviousGame.Response())
    }
}
