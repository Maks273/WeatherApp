//
//  HourlyWeatherView.swift
//  WeatherWidgetExtension
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI

struct HourlyWeatherView: View {
    let model: ForecastModel
    let timeZone: String
    
    var body: some View {
        VStack (alignment: .center) {
            Text(model.date?.convertDate(with: "ha", timeZone: timeZone) ?? "")
                .font(.system(size: 12)).fontWeight(.medium)
                .foregroundColor(.white)
                .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            Spacer(minLength: 3)
            Image(model.weather.first?.iconName ?? "")
                .resizable()
                .frame(width: 32, height: 30, alignment: .bottom)
                .aspectRatio(contentMode: .fit)
            Spacer(minLength: 3)
            Text("\(Int(model.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º")
                .font(.system(size: 13)).fontWeight(.medium)
                .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
        }.padding()
    }
}


