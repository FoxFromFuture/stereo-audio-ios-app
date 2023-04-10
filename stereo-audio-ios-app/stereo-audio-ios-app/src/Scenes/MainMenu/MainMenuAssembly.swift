//
//  MainMenuAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum MainMenuAssembly {
    static func build() -> UIViewController {
        let router: MainMenuRouter = MainMenuRouter()
        let presenter: MainMenuPresenter = MainMenuPresenter()
        let interactor: MainMenuInteractor = MainMenuInteractor(presenter: presenter)
        let viewController: MainMenuViewController = MainMenuViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
