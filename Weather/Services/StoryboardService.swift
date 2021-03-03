//
//  StoryboardService.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

enum StoryboardService: String {
    case main = "Main"
    
    private var instance: UIStoryboard? {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let VC = instance?.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("Error with getting view controller \(storyboardID)")
        }
        return VC
    }
}
