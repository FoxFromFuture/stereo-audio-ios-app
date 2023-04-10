//
//  MainMenuInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 28.02.2023.
//

import UIKit

protocol MainMenuBusinessLogic {
    typealias Model = MainMenuModel
    func loadStart(_ request: Model.Start.Request)
    func loadStartGameScene(_ request: Model.StartGame.Request)
    func loadShopScene(_ request: Model.Shop.Request)
    func loadNewLanguage(_ request: Model.Language.Request)
    func loadTutorialScene(_ request: Model.Tutorial.Request)
}

final class MainMenuInteractor {
    // MARK: - Fields
    private let presenter: MainMenuPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: MainMenuPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension MainMenuInteractor: MainMenuBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        var otherLanguage = ""
        if curLanguage == Language.en.str {
            otherLanguage = Language.ru.str
        } else {
            otherLanguage = Language.en.str
        }
        presenter.presentStart(Model.Start.Response(lng: curLanguage, otherLng: otherLanguage))
    }
    
    func loadNewLanguage(_ request: Model.Language.Request) {
        UserDefaults.standard.set(request.lng, forKey: "lng")
        presenter.presentNewLanguage(Model.Language.Response(lng: request.lng))
    }
    
    func loadStartGameScene(_ request: Model.StartGame.Request) {
        presenter.presentStartGameScene(Model.StartGame.Response())
    }
    
    func loadShopScene(_ request: Model.Shop.Request) {
        presenter.presentShopScene(Model.Shop.Response())
    }
    
    func loadTutorialScene(_ request: Model.Tutorial.Request) {
        presenter.presentTutorialScene(Model.Tutorial.Response())
    }
}
