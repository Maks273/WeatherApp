//
//  IntentHandler.swift
//  WeatherIntentExtension
//
//  Created by Макс Пайдич on 14.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import Intents

class IntentHandler: INExtension, SelectCityIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
    func provideCityOptionsCollection(for intent: SelectCityIntent, with completion: @escaping (INObjectCollection<CityParameter>?, Error?) -> Void) {
        let cities = UserDefaultsService.shared.loadCityDataSource()
        var cityParams: [CityParameter] = [CityParameter.defaultLocation]
        cityParams.append(contentsOf: cities.map { CityParameter(city: $0) })
        
        completion(INObjectCollection(items: cityParams), nil)
    }
    
    
}
