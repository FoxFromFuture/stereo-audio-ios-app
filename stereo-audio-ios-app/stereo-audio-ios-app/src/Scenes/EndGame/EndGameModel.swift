//
//  EndGameModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

enum EndGameModel {
    enum Start {
        struct Request { }
        struct Response {
            let lng: String
        }
        struct ViewModel {
            let lng: String
        }
        struct Info { }
    }
    
    enum MainMenu {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum PreviousGame {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
}
