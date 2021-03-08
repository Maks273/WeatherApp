//
//  CityModel.swift
//  Weather
//
//  Created by Макс Пайдич on 07.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import Foundation

class CityModel: Codable {
    
    //MARK: - Variables
    
    var name: String?
    var timeZone: String?
    var lat: Double?
    var lng: Double?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name, timeZone, lat, lng, id
    }
    
    //MARK: - Initalizers
    
    init(name: String?, timeZone: String?, lat: Double?, lng: Double?, id: String?) {
        self.name = name
        self.timeZone = timeZone
        self.lat = lat
        self.lng = lng
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = try? container.decode(String.self, forKey: .name)
            timeZone = try? container.decode(String.self, forKey: .timeZone)
            lat = try? container.decode(Double.self, forKey: .lat)
            lng = try? container.decode(Double.self, forKey: .lng)
            id = try? container.decode(String.self, forKey: .id)
        }catch(let error) {
            NSLog("Decode error \(error.localizedDescription)")
        }
    }
    
    //MARK: - Helper
    
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(name, forKey: .name)
            try container.encode(timeZone, forKey: .timeZone)
            try container.encode(lat, forKey: .lat)
            try container.encode(lng, forKey: .lng)
            try container.encode(id, forKey: .id)
        }catch(let error) {
            NSLog("Encode error \(error.localizedDescription)")
        }
    }
}
