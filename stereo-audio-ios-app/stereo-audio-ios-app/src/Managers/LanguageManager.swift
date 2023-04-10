//
//  LanguageManager.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

class LanguageManager {
    
    // MARK: - Fields
    static let shared = LanguageManager()
    
    // MARK: - LifeCycle
    private init() { }
    
    func getCurrentLanguage() -> String {
        return UserDefaults.standard.string(forKey: "lng") ?? Language.en.str
    }
}
