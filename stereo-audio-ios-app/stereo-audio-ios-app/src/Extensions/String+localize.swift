//
//  String+localize.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

extension String {
    func localize(lng: String) -> String {
        let path = Bundle.main.path(forResource: lng, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, bundle: bundle!, comment: "")
    }
}
