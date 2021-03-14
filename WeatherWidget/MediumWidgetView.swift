//
//  MediumWidgetView.swift
//  Weather
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    
    var data: WidgetContent
    
    var body: some View {
        VStack {
        HStack {
            VStack(alignment: .leading) {
                Text(data.cityName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(Int(data.temperature.rounded(.toNearestOrEven)))º")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer(minLength:100)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(data.description)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .bold()
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("H:\(Int(data.highTemperature.rounded(.toNearestOrEven)))º")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .bold()
                    Text("L:\(Int(data.lowTemperature.rounded(.toNearestOrEven)))º")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .bold()
                }
                Spacer(minLength:100)
            }
        }.padding(8)
        .padding(.leading, 10)
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 116/255, green: 172/255, blue: 247/255), Color(red: 116/255, green: 172/255, blue: 247/255), Color(red: 85/255, green: 98/255, blue: 225/255)]), startPoint: .top, endPoint: .bottom))

        }
        
    }
}

struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView(data: .mock).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
