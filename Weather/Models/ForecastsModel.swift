//
//  ForecastsModel.swift
//  Weather
//
//  Created by Макс Пайдич on 07.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class ForecastsModel: Codable {
    
    //MARK: - Variables
    
    var current: ForecastModel?
    var daily: [ForecastModel] = []
    var timezone: String?
    var cityName: String?
    var hourly: [ForecastModel] = []
    var lat: Double?
    var lon: Double?
    var cityId: String?
    
    enum CodingKeys: String, CodingKey {
        case current, timezone, daily, hourly, lat, lon
    }
    
    //MARK: - Initalizers
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            current = try? container.decode(ForecastModel.self, forKey: .current)
            daily = try container.decode([ForecastModel].self, forKey: .daily)
            timezone = try? container.decodeIfPresent(String.self, forKey: .timezone)
            hourly = try container.decode([ForecastModel].self, forKey: .hourly)
            lat = try? container.decodeIfPresent(Double.self, forKey: .lat)
            lon = try? container.decodeIfPresent(Double.self, forKey: .lon)
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
}
