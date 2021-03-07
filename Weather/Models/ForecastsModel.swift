//
//  ForecastsModel.swift
//  Weather
//
//  Created by Макс Пайдич on 07.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class ForecastsModel: Codable {
    
    var current: ForecastModel?
    var daily: [ForecastModel] = []
    var timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case current, timezone, daily
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            current = try? container.decode(ForecastModel.self, forKey: .current)
            daily = try container.decode([ForecastModel].self, forKey: .daily)
            timezone = try? container.decodeIfPresent(String.self, forKey: .timezone)
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
}
