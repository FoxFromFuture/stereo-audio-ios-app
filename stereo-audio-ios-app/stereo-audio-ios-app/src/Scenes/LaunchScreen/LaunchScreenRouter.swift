//
//  LaunchScreenRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit

protocol LaunchScreenRoutingLogic {
    func routeToMainMenuViewController()
}

final class LaunchScreenRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension LaunchScreenRouter: LaunchScreenRoutingLogic {
    func routeToMainMenuViewController() {
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: false)
    }
}
