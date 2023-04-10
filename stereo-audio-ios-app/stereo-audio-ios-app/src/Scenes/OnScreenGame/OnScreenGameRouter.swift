//
//  OnScreenGameRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

import UIKit

protocol OnScreenGameRoutingLogic {
    func routeToEndGameScene()
}

final class OnScreenGameRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension OnScreenGameRouter: OnScreenGameRoutingLogic {
    func routeToEndGameScene() {
        view?.navigationController?.pushViewController(EndGameAssembly.build(), animated: false)
    }
}
