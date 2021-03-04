//
//  NextDaysRouter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol NextDaysRouter {
    func popToViewController()
}

class NextDaysRouterImplementation: NextDaysRouter {
    
    //MARK: - Variables
    
    private let viewConttroller: UIViewController
    
    //MARK: Initalizer
    
    init(viewConttroller: NextDaysViewController) {
        self.viewConttroller = viewConttroller
    }
    
    //MARK: - Helper
    
    func popToViewController() {
        viewConttroller.navigationController?.popViewController(animated: true)
    }
    
    
}
