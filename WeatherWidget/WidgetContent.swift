//
//  WidgetContent.swift
//  Weather
//
//  Created by Макс Пайдич on 12.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import WidgetKit

struct WidgetContent {
    var cityName: String
    var temperature: Double
    var imageName: String
    var highTemperature: Double
    var lowTemperature: Double
    var description: String
    var items: [String] = ["1", "2", "3", "4", "5"]
}

extension WidgetContent {
    static let mock = WidgetContent(cityName: "Uzhhorod", temperature: 1, imageName: "01d", highTemperature: 2, lowTemperature: 1, description: "Sunny")
}
