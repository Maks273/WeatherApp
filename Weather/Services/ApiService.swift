//
//  ApiService.swift
//  Weather
//
//  Created by Макс Пайдич on 06.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

typealias WeatherModelCompletion = (_ error: Error?, _ model: ForecastsModel?) -> Void

class ApiService {
    
    //MARK: - Variables
    
    static let shared = ApiService()
    
    private let apiKey = "f2f33e14c667e1ea76a70a2c9f1c0350"
    private let baseURL = "https://api.openweathermap.org/data/2.5/onecall?appid="
    
    //MARK: - Initalizer
    
    private init () {}
    
    //MARK: - Helper
    
    func getCurrentWeather(location: CLLocationCoordinate2D, callback: @escaping WeatherModelCompletion) {
        
        let params: Parameters = ["lat": location.latitude, "lon": location.longitude, "units": UserDefaultsService.shared.getTemperatureMetric() ?? "metric"]
        AF.request(baseURL.appending(apiKey), method: .get, parameters: params, encoding: URLEncoding(destination: .queryString)).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if let data = response.data {
                    do {
                        let model = try JSONDecoder().decode(ForecastsModel.self, from: data)
                        callback(nil,model)
                    }catch(let error) {
                        callback(error,nil)
                    }
                }
            case .failure(let error):
                callback(error,nil)
            }
            
        }
    }
    
}
