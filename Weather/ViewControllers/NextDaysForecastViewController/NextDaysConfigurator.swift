//
//  NextDaysConfigurator.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol NextDaysConfigurator {
    func configure(_ viewController: NextDaysViewController, model: ForecastsModel)
}

class NextDaysConfiguratorImplementation: NextDaysConfigurator {
    
    func configure(_ viewController: NextDaysViewController, model: ForecastsModel) {
        let router: NextDaysRouter = NextDaysRouterImplementation(viewConttroller: viewController)
        let presenter: NextDaysPresenter = NextDaysPresenterImplementation(view: viewController, router: router, model: model)
        
        viewController.presenter = presenter
    }
    
}
