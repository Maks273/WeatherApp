//
//  CityForecastRouter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol CityForecastRouter {
    func showNextDaysScreen(with model: ForecastsModel)
    func showFindCityScreen()
}

class CityForecastRouterImplementation: CityForecastRouter {
    
    //MARK: - Variables
    
    private let viewController: CityForecastViewController
    
    //MARK: - Initalizer
    
    init(viewController: CityForecastViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Helper
    
    func showNextDaysScreen(with model: ForecastsModel) {
        let nextDays = StoryboardService.main.viewController(viewControllerClass: NextDaysViewController.self)
        nextDays.configurator.configure(nextDays, model: model)
        viewController.navigationController?.pushViewController(nextDays, animated: true)
    }
    
    func showFindCityScreen() {
        let findCityVC = StoryboardService.main.viewController(viewControllerClass: FindCityViewController.self)
        findCityVC.configurator.configure(findCityVC)
        viewController.navigationController?.pushViewController(findCityVC, animated: true)
    }
}


