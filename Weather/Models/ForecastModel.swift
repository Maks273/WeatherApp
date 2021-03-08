//
//  WeatherModel.swift
//  Weather
//
//  Created by Макс Пайдич on 06.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class ForecastModel: Codable {
    
    //MARK: - Variables
    
    var clouds: Int?
    var uvi: Double?
    var windSpeed: Double?
    var visibility: Double?
    var pressure: Double?
    var humidity: Double?
    var date: Date?
    var sunset: Date?
    var sunrise: Date?
    var weather: [WeatherModel] = []
    var feelsLike: FeelsLike?
    var feelsLikeCurrent: Double?
    var currentTemperature: Double?
    var temperature: Temperature?
    var windDegrees: Double?
    
    enum CodingKeys: String, CodingKey {
        case clouds, visibility, uvi, pressure, humidity, sunset, sunrise, weather
        case windSpeed = "wind_speed"
        case date = "dt"
        case feelsLike = "feels_like"
        case temperature = "temp"
        case windDegrees = "wind_deg"
        
    }
    
    //MARK: - Initalizer
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            clouds = try? container.decode(Int.self, forKey: .clouds)
            uvi = try? container.decode(Double.self, forKey: .uvi)
            windSpeed = try? container.decode(Double.self, forKey: .windSpeed)
            visibility = try? container.decode(Double.self, forKey: .visibility)
            pressure = try? container.decode(Double.self, forKey: .pressure)
            humidity = try? container.decode(Double.self, forKey: .humidity)
            
            if let timeIntervalDate = try? container.decode(Int.self, forKey: .date) {
                date = Date(timeIntervalSince1970: TimeInterval(timeIntervalDate))
            }
            
            if let sunsetIntervarDate = try? container.decode(Int.self, forKey: .sunset) {
                sunset = Date(timeIntervalSince1970: TimeInterval(sunsetIntervarDate))
            }
            
            if let sunriseIntervalDate = try? container.decode(Int.self, forKey: .sunrise) {
                sunrise = Date(timeIntervalSince1970: TimeInterval(sunriseIntervalDate))
            }
            
            weather = try container.decode([WeatherModel].self, forKey: .weather)
            
            if let feelsLikeNumber = try? container.decode(Double.self, forKey: .feelsLike) {
                feelsLikeCurrent = feelsLikeNumber
            }else {
                feelsLike = try? container.decode(FeelsLike.self, forKey: .feelsLike)
            }
            
            if let currentTemperature = try? container.decode(Double.self, forKey: .temperature) {
                self.currentTemperature = currentTemperature
            }else {
                temperature = try? container.decode(Temperature.self, forKey: .temperature)
            }
            
            windDegrees = try? container.decode(Double.self, forKey: .windDegrees)
            
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
    
}

