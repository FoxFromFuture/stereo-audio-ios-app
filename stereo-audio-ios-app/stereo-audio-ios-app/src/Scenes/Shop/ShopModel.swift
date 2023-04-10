//
//  ShopModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

enum ShopModel {
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
    
    enum UserProducts {
        struct Request { }
        struct Response {
            let isFirstUsed: Bool
        }
        struct ViewModel {
            let isFirstUsed: Bool
        }
        struct Info { }
    }
    
    enum EnemyProducts {
        struct Request { }
        struct Response {
            let isFirstUsed: Bool
        }
        struct ViewModel {
            let isFirstUsed: Bool
        }
        struct Info { }
    }
    
    enum NextProduct {
        struct Request {
            let arrowButtonSide: String
            let curViewedProductIndex: Int
            let isUserButtonPressed: Bool
        }
        struct Response {
            let arrowButtonSide: String
            let productName: String
            let productImage: UIImage
            let isProductBoundaryInList: Bool
            let status: String
            let curViewedProductIndex: Int
        }
        struct ViewModel {
            let arrowButtonSide: String
            let productName: String
            let productImage: UIImage
            let isProductBoundaryInList: Bool
            let status: String
            let curViewedProductIndex: Int
        }
        struct Info { }
    }
    
    enum NewProductStatus {
        struct Request {
            let curViewedProductIndex: Int
            let isUserButtonPressed: Bool
        }
        struct Response {
            let newStatus: String
        }
        struct ViewModel {
            let newStatus: String
        }
        struct Info {
            let newStatus: String
        }
    }
}
