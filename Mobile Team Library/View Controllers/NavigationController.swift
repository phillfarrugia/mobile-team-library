//
//  NavigationController.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topMostViewController = viewControllers.first {
            return topMostViewController.preferredStatusBarStyle
        }
        return .default
    }
    
}
