//
//  MediumWeatherView.swift
//  WeatherWidgetExtension
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MediumWeatherView: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        VStack {
            Spacer(minLength: 15)
            HStack {
                VStack(alignment: .leading) {
                    Spacer(minLength: 15)
                    Text(entry.weatherInfo.cityName ?? "")
                        .font(.system(size: 16)).fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("\(Int(entry.weatherInfo.current?.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer(minLength: 12)
                    Image(entry.weatherInfo.current?.weather.first?.iconName ?? "")
                        .resizable()
                        .frame(width: 30, height: 25, alignment: .bottom)
                    Spacer(minLength: 0)
                    Text(entry.weatherInfo.current?.weather.first?.description?.capitalized ?? "")
                        .font(.system(size: 14)).bold()
                        .foregroundColor(.white)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Text("H:\(Int(entry.weatherInfo.daily.first?.temperature?.max?.rounded(.toNearestOrEven) ?? 0))º")
                            .font(.system(size: 14)).bold()
                            .foregroundColor(.white)
                        Text("L:\(Int(entry.weatherInfo.daily.first?.temperature?.min?.rounded(.toNearestOrEven) ?? 0))º")
                            .font(.system(size: 14)).bold()
                            .foregroundColor(.white)
                    }

                }
            }
            Spacer(minLength: 0)
            HStack {
                if entry.weatherInfo.hourly.count >= 5 {
                    ForEach(0..<5){ index in
                        HourlyWeatherView(model: entry.weatherInfo.hourly[index], timeZone: entry.weatherInfo.timezone ?? "")
                    }
                }
            }
            Spacer(minLength: 8)
        }.padding(.all, 12)
        .background(LinearGradient.bluePurpleGradient)
    }
}
