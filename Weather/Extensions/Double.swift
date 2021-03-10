//
//  Double.swift
//  Weather
//
//  Created by Макс Пайдич on 10.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import Foundation

extension Double {
    func windDirectionFromDegrees() -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((self + 11.25)/22.5)
        return directions[i % 16]
    }
}
