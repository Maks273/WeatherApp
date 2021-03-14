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
    
    let userDefault = UserDefaults(suiteName: "group.com.paydich.Weather")
    static let shared = UserDefaultsService()
    
    //MARK: - Initalizer
    
    private init() {}
    
    //MARK: - Helper
    
    func saveTemperatureMetric(metric: String) {
        userDefault?.set(metric, forKey: "temperaturMetric")
    }
    
    func getTemperatureMetric() -> String? {
        return userDefault?.string(forKey: "temperaturMetric")
    }
    
    func loadCityDataSource() -> [CityModel] {
        if let data = userDefault?.object(forKey: "cityItems") as? Data {
            if let decodeDataSource = try? JSONDecoder().decode([CityModel].self, from: data) {
                return decodeDataSource
            }
        }
        return []
    }
    
    func saveCityDataSource(_ dataSource: [CityModel]) {
         if let data = try? JSONEncoder().encode(dataSource) {
             userDefault?.set(data, forKey: "cityItems")
         }
     }
}
