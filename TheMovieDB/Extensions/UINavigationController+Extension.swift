//
//  UINavigationController+Extension.swift
//  TheMovieDB
//
//  Created by Dedy Yuristiawan on 28/04/20.
//  Copyright © 2020 Dedy Yuristiawan. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    @objc public class func currentActiveNavigationController() -> UINavigationController? {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let navi = keyWindow?.rootViewController?.presentedViewController as? UINavigationController {
            return navi
        }
        let windows = UIApplication.shared.windows;
        var ortherNavi: UINavigationController?
        
        for oneWindow in windows {
            if let tab = oneWindow.rootViewController as? UITabBarController {
                return tab.selectedViewController as? UINavigationController
            }
            if let navi = oneWindow.rootViewController as? UINavigationController {
                ortherNavi =  navi
            }
        }
        return ortherNavi
    }
    
}
