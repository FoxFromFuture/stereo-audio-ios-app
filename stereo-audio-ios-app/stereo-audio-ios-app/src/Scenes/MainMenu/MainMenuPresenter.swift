//
//  MainMenuPresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 28.02.2023.
//

import UIKit

protocol MainMenuPresentationLogic {
    typealias Model = MainMenuModel
    func presentStart(_ response: Model.Start.Response)
    func presentNewLanguage(_ response: Model.Language.Response)
    func presentStartGameScene(_ response: Model.StartGame.Response)
    func presentShopScene(_ response: Model.Shop.Response)
    func presentTutorialScene(_ response: Model.Tutorial.Response)
}

final class MainMenuPresenter {
    // MARK: - Fields
    weak var view: MainMenuDisplayLogic?
}

// MARK: - PresentationLogic
extension MainMenuPresenter: MainMenuPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng, otherLng: response.otherLng))
    }
    
    func presentNewLanguage(_ response: Model.Language.Response) {
        view?.displayNewLanguage(Model.Language.ViewModel(lng: response.lng))
    }
    
    func presentStartGameScene(_ response: Model.StartGame.Response) {
        view?.displayStartGameScene(Model.StartGame.ViewModel())
    }
    
    func presentShopScene(_ response: Model.Shop.Response) {
        view?.displayShopScene(Model.Shop.ViewModel())
    }
    
    func presentTutorialScene(_ response: Model.Tutorial.Response) {
        view?.displayTutorialScene(Model.Tutorial.ViewModel())
    }
}
