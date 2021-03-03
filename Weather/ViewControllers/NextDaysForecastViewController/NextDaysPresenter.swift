//
//  NextDaysPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol NextDaysView: class {
    
}

protocol NextDaysPresenter {
    var router: NextDaysRouter {get}
    
    func title() -> String
    func numberOfRow() -> Int
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

class NextDaysPresenterImplementation : NextDaysPresenter {
    
    //MARK: - Variables
    
    unowned let view: NextDaysView
    let router: NextDaysRouter
    
    
    //MARK: - Initalizer
    
    init(view: NextDaysView, router: NextDaysRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func title() -> String {
        return "Uzhhorod, Ukraine"
    }
    
    func numberOfRow() -> Int {
        return 0
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
