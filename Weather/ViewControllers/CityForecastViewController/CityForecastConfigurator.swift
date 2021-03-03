//
//  CityForecastConfigurator.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol CityForecastConfigurator {
    func configure(_ viewController: CityForecastViewController)
}

class CityForecastConfiguratorImplementation: CityForecastConfigurator {
    
    func configure(_ viewController: CityForecastViewController) {
        
        let router: CityForecastRouter = CityForecastRouterImplementation(viewController: viewController)
        let presenter: CityForecastPresenter = CityForecastPresenterImplementation(view: viewController, router: router)
        
        viewController.presenter = presenter
    }
    
}

