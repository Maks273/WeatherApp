//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SmallWeatherView: View {
    let entry: WeatherEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(entry.weatherInfo.cityName ?? "")
                    .font(.system(size: 16)).fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(Int(entry.weatherInfo.current?.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Image(entry.weatherInfo.current?.weather.first?.iconName ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(entry.weatherInfo.current?.weather.first?.description?.capitalized(with: nil) ?? "")
                    .font(.system(size: 12)).bold()
                    .foregroundColor(.white)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("H:\(Int(entry.weatherInfo.daily.first?.temperature?.max?.rounded(.toNearestOrEven) ?? 0))º")
                        .font(.system(size: 12)).bold()
                        .foregroundColor(.white)
                    Text("L:\(Int(entry.weatherInfo.daily.first?.temperature?.min?.rounded(.toNearestOrEven) ?? 0))º")
                        .font(.system(size: 12)).bold()
                        .foregroundColor(.white)
                }
            }.padding(.top, 4)
            .padding(.bottom, 10)
            .padding(.leading, 10)
            Spacer()
        }.background(LinearGradient.bluePurpleGradient)
    }
}

