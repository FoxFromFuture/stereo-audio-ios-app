//
//  LaunchScreenInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit

protocol LaunchScreenBusinessLogic {
    typealias Model = LaunchScreenModel
    func loadStart(_ request: Model.Start.Request)
    func loadUserDefaults()
    func loadMainMenuScene(_ request: Model.MainMenu.Request)
}

final class LaunchScreenInteractor {
    // MARK: - Fields
    private let presenter: LaunchScreenPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: LaunchScreenPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension LaunchScreenInteractor: LaunchScreenBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadUserDefaults() {
        if UserDefaults.standard.string(forKey: "lng") == nil {
            UserDefaults.standard.set("en", forKey: "lng")
        }
        if UserDefaults.standard.string(forKey: "user") == nil || UserDefaults.standard.string(forKey: "enemy") == nil {
            UserDefaults.standard.set("user", forKey: "user")
            UserDefaults.standard.set("alien", forKey: "enemy")
        }
        if UserDefaults.standard.value(forKey: "bestScore") == nil {
            UserDefaults.standard.set(0, forKey: "bestScore")
        }
        if UserDefaults.standard.value(forKey: "coins") == nil {
            UserDefaults.standard.set(0, forKey: "coins")
        }
        if UserDefaults.standard.value(forKey: "ownProducts") == nil {
            UserDefaults.standard.set(["user", "alien"], forKey: "ownProducts")
        }
        UserDefaults.standard.set(0, forKey: "score")
    }
    
    func loadMainMenuScene(_ request: Model.MainMenu.Request) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.presenter.presentMainMenuScene(Model.MainMenu.Response())
        }
    }
}
