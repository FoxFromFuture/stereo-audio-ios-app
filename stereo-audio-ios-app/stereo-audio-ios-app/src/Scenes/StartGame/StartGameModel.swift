//
//  StartGameModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

enum StartGameModel {
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
    
    enum OnScreenGame {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum ARGame {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum CameraAccess {
        struct Request { }
        struct Response {
            let alert: UIAlertController
        }
        struct ViewModel {
            let alert: UIAlertController
        }
        struct Info { }
    }
}
