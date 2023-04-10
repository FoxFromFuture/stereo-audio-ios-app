//
//  EndGameAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum EndGameAssembly {
    static func build() -> UIViewController {
        let router: EndGameRouter = EndGameRouter()
        let presenter: EndGamePresenter = EndGamePresenter()
        let interactor: EndGameInteractor = EndGameInteractor(presenter: presenter)
        let viewController: EndGameViewController = EndGameViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
