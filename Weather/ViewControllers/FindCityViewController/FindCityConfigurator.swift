//
//  FindCityConfigurator.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol FindCityConfigurator {
    func configure(_ viewController: FindCityViewController)
}

class FindCityConfiguratorImplementation: FindCityConfigurator {
    
    func configure(_ viewController: FindCityViewController) {
        let router: FindCityRouter = FindCityRouterImplementation(viewController: viewController)
        let presenter: FindCityPresenter = FindCityPresenterImplementation(view: viewController, router: router)
        viewController.presenter = presenter
    }
    
}
