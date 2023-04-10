//
//  StartGamePresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol StartGamePresentationLogic {
    typealias Model = StartGameModel
    func presentStart(_ response: Model.Start.Response)
    func presentMainMenuScene(_ response: Model.MainMenu.Response)
    func presentOnScreenGameScene(_ response: Model.OnScreenGame.Response)
    func presentARGameScene(_ response: Model.ARGame.Response)
    func presentCameraAccessAlert(_ response: Model.CameraAccess.Response)
}

final class StartGamePresenter {
    // MARK: - Fields
    weak var view: StartGameDisplayLogic?
}

// MARK: - PresentationLogic
extension StartGamePresenter: StartGamePresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentMainMenuScene(_ response: Model.MainMenu.Response) {
        view?.displayMainMenuScene(Model.MainMenu.ViewModel())
    }
    
    func presentOnScreenGameScene(_ response: Model.OnScreenGame.Response) {
        view?.displayOnScreenGameScene(Model.OnScreenGame.ViewModel())
    }
    
    func presentARGameScene(_ response: Model.ARGame.Response) {
        view?.displayARGameScene(Model.ARGame.ViewModel())
    }
    
    func presentCameraAccessAlert(_ response: Model.CameraAccess.Response) {
        view?.displayCameraAccessAlert(Model.CameraAccess.ViewModel(alert: response.alert))
    }
}
