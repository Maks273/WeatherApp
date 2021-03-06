//
//  FindCityRouter.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol FindCityRouter {
    func popToViewController()
}

class FindCityRouterImplementation: FindCityRouter {
    
    //MARK: - Variables
    
    private var viewController: UIViewController
    
    //MARK: - Initalizer
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Helper
    
    func popToViewController() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
}