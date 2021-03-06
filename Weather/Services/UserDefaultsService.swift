//
//  UserDefaultsService.swift
//  Weather
//
//  Created by Макс Пайдич on 06.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class UserDefaultsService {
    
    //MARK: - Variables
    
    static let shared = UserDefaultsService()
    
    //MARK: - Initalizer
    
    private init() {}
    
    //MARK: - Helper
    
    func saveTemperatureMetric(metric: String) {
        UserDefaults.standard.set(metric, forKey: "temperaturMetric")
    }
    
    func getTemperatureMetric() -> String? {
        return UserDefaults.standard.string(forKey: "temperaturMetric")
    }
}
