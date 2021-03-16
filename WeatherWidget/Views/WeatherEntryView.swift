//
//  WeatherEntryView.swift
//  WeatherWidgetExtension
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI

struct WeatherEntryView: View {
    let entry: WeatherEntry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWeatherView(entry: entry)
        case .systemMedium:
            MediumWeatherView(entry: entry)
        case .systemLarge:
           Text("Not supported")
        default:
            ZStack {
            }.edgesIgnoringSafeArea(.all)
        }
    }
}
