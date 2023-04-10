//
//  TutorialAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

enum TutorialAssembly {
    static func build() -> UIViewController {
        let router: TutorialRouter = TutorialRouter()
        let presenter: TutorialPresenter = TutorialPresenter()
        let interactor: TutorialInteractor = TutorialInteractor(presenter: presenter)
        let viewController: TutorialViewController = TutorialViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
