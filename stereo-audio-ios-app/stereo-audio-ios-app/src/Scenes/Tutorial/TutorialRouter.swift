//
//  TutorialRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

protocol TutorialRoutingLogic {
    func routeToSoundLicenseWebsite()
}

import UIKit

final class TutorialRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension TutorialRouter: TutorialRoutingLogic {
    func routeToSoundLicenseWebsite() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let url = URL(string: "https://quicksounds.com")
        UIApplication.shared.open(url!)
    }
}
