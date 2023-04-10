//
//  LaunchScreenPresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit

protocol LaunchScreenPresentationLogic {
    typealias Model = LaunchScreenModel
    func presentStart(_ response: Model.Start.Response)
    func presentMainMenuScene(_ response: Model.MainMenu.Response)
}

final class LaunchScreenPresenter {
    // MARK: - Fields
    weak var view: LaunchScreenDisplayLogic?
}

// MARK: - PresentationLogic
extension LaunchScreenPresenter: LaunchScreenPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentMainMenuScene(_ response: Model.MainMenu.Response) {
        view?.displayMainMenuScene(Model.MainMenu.ViewModel())
    }
}
