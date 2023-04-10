//
//  StartGameAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum StartGameAssembly {
    static func build() -> UIViewController {
        let router: StartGameRouter = StartGameRouter()
        let presenter: StartGamePresenter = StartGamePresenter()
        let interactor: StartGameInteractor = StartGameInteractor(presenter: presenter)
        let viewController: StartGameViewController = StartGameViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
