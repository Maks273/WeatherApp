//
//  FindCityPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol FindCityView: class {
    
}

protocol FindCityPresenter {
    var router: FindCityRouter {get}
}

class FindCityPresenterImplementation: FindCityPresenter {
    
    //MARK: - Variables
    
    unowned var view: FindCityView
    var router: FindCityRouter
    
    
    //MARK: - Initalizer
    
    init(view: FindCityView, router: FindCityRouter) {
        self.view = view
        self.router = router
    }
    
}
