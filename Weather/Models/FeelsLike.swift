//
//  FeelsLike.swift
//  Weather
//
//  Created by Макс Пайдич on 07.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class FeelsLike: Codable {
    
    var day: Double?
    var eve: Double?
    var morn: Double?
    var night: Double?
    
    enum CodingKeys: String, CodingKey {
        case day, eve, morn, night
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            day = try? container.decode(Double.self, forKey: .day)
            eve = try? container.decode(Double.self, forKey: .eve)
            morn = try? container.decode(Double.self, forKey: .morn)
            night = try? container.decode(Double.self, forKey: .night)
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
}
