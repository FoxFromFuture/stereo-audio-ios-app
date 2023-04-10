//
//  Language.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum Language {
    case en
    case ru
    
    var str: String {
        switch self {
        case .en:
            return "en"
        case .ru:
            return "ru"
        }
    }
}
