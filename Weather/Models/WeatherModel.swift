//
//  WeatherModel.swift
//  Weather
//
//  Created by Макс Пайдич on 07.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class WeatherModel: Codable {
    
    var description: String?
    var main: String?
    var iconName: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case description, id, main
        case iconName = "icon"
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            description = try container.decode(String.self, forKey: .description)
            main = try container.decode(String.self, forKey: .main)
            iconName = try container.decode(String.self, forKey: .iconName)
            id = try container.decode(Int.self, forKey: .id)
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
}
