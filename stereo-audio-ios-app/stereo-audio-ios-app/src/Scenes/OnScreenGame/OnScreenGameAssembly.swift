//
//  OnScreenGameAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum OnScreenGameAssembly {
    static func build() -> UIViewController {
        let router: OnScreenGameRouter = OnScreenGameRouter()
        let presenter: OnScreenGamePresenter = OnScreenGamePresenter()
        let interactor: OnScreenGameInteractor = OnScreenGameInteractor(presenter: presenter)
        let viewController: OnScreenGameViewController = OnScreenGameViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
