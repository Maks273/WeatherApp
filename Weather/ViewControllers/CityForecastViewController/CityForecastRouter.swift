//
//  CityForecastRouter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol CityForecastRouter {
    
}

class CityForecastRouterImplementation: CityForecastRouter {
    
    //MARK: - Variables
    
    private let viewController: CityForecastViewController
    
    //MARK: - Initalizer
    
    init(viewController: CityForecastViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Helper
    
}


