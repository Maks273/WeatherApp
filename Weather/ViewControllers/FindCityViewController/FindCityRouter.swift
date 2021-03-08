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
    func showCityForecastScreen(with model: ForecastsModel, showAsModal: Bool)
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
    
    func showCityForecastScreen(with model: ForecastsModel, showAsModal: Bool) {
        let cityForecastVC = StoryboardService.main.viewController(viewControllerClass: CityForecastViewController.self)
        cityForecastVC.configurator.configure(cityForecastVC, model: model)
        DispatchQueue.main.async {
            if showAsModal {
                cityForecastVC.modalPresentationStyle = .fullScreen
                self.viewController.present(cityForecastVC, animated: true, completion: nil)
            }else {
                self.viewController.navigationController?.pushViewController(cityForecastVC, animated: true)
            }
        }
    }
    
}
