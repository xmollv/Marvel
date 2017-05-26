//
//  UIKit+Extensions.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

enum MarvelStoryboard: String {
    // The cases of this enum start with a capital letter to match the name of the .storyboard when using its rawValue
    case TabBarViewController
}

extension UIViewController {
    class func instantiateFrom(storyboard: MarvelStoryboard) -> Self {
        return instantiateFromStoryboardHelper(type: self, storyboardName: storyboard.rawValue)
    }
    
    private class func instantiateFromStoryboardHelper<T>(type: T.Type, storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: type.self)) as! T
    }
}
