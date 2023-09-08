//
//  StoryboardExtension.swift
//  Gaxa
//
//  Created by karim metawea on 5/31/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController {

class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {

    let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
    let identifier = String(describing: self)
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}
}
extension String {
    var localized: String {

//    var result: String
//
//    let languageCode = Locale.preferredLanguage //en-US
//
//    var path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
//
//    if path == nil, let hyphenRange = languageCode.range(of: "-") {
//        let languageCodeShort = languageCode.substring(to: hyphenRange.lowerBound) // en
//        path = Bundle.main.path(forResource: languageCodeShort, ofType: "lproj")
//    }
//
//    if let path = path, let locBundle = Bundle(path: path) {
//        result = locBundle.localizedString(forKey: self, value: nil, table: nil)
//    } else {
//        result = NSLocalizedString(self, comment: "")
//    }
        return NSLocalizedString(self, comment: "")
    }
}
