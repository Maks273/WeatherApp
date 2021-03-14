//
//  WidgetView.swift
//  Weather
//
//  Created by Макс Пайдич on 12.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    let data: WidgetContent
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Text(data.cityName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(Int(data.temperature.rounded(.toNearestOrEven)))º")
                        .font(.title)
                        .foregroundColor(.white)
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
                }.padding(8)
                .padding(.leading, 10)
                Spacer()
            }.background(LinearGradient(gradient: Gradient(colors: [Color(red: 116/255, green: 172/255, blue: 247/255), Color(red: 116/255, green: 172/255, blue: 247/255), Color(red: 85/255, green: 98/255, blue: 225/255)]), startPoint: .top, endPoint: .bottom))
        case .systemMedium:
            MediumWidgetView(data: .mock)
        case .systemLarge:
            Text("")
        @unknown default:
            Text("")
        }
        
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetView(data: .mock).previewContext(WidgetPreviewContext(family: .systemSmall))
            MediumWidgetView(data: .mock).previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
