//
//  OnScreenGameModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

enum OnScreenGameModel {
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
    
    enum Game {
        struct Request {
            let sublayer: CALayer
            let frame: CGRect
        }
        struct Response {
            let pressAction: ((Int) -> Void)
            let touchesBeganAction: ((Int) -> CGColor)
        }
        struct ViewModel {
            let pressAction: ((Int) -> Void)
            let touchesBeganAction: ((Int) -> CGColor)
        }
        struct Info { }
    }
    
    enum NewScore {
        struct Request { }
        struct Response {
            let score: Int
        }
        struct ViewModel {
            let score: Int
        }
        struct Info { }
    }
    
    enum EndGameScene {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
}
