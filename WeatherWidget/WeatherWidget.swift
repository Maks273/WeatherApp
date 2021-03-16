//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Макс Пайдич on 13.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct WeatherTimeline: IntentTimelineProvider {
    
    typealias Intent = SelectCityIntent
    typealias Entry = WeatherEntry
    let locationManager = CLLocationManager()
    
    func placeholder(in context: Context) -> WeatherEntry {
        
        let weatherSnap = ForecastsModel()
        let entry = WeatherEntry(date: Date(), weatherInfo: weatherSnap)
        
        return entry
    }
    
    func getSnapshot(for configuration: SelectCityIntent, in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        if let latitude = CityParameter.defaultLocation.latitude?.doubleValue, let longitude = CityParameter.defaultLocation.longitude?.doubleValue, latitude != 0, longitude != 0  {
            loadForecastModel(location: CLLocation(latitude: latitude, longitude: longitude)) { (model) in
                if let model = model {
                    let entry = WeatherEntry(date: Date(), weatherInfo: model)
                    completion(entry)
                }
            }
        }
    }
    
    func getTimeline(for configuration: SelectCityIntent, in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        var latitude: Double? = nil
        var longitude: Double? = nil
        
        if configuration.city?.latitude?.doubleValue == nil && configuration.city?.longitude?.doubleValue == nil {
            latitude = CityParameter.defaultLocation.latitude?.doubleValue == 0 ? nil : CityParameter.defaultLocation.latitude?.doubleValue
            longitude = CityParameter.defaultLocation.longitude?.doubleValue
        }else {
            latitude = configuration.city?.latitude?.doubleValue
            longitude = configuration.city?.longitude?.doubleValue
        }
        
        if let latitude = latitude, let longitude = longitude {
            loadForecastModel(location: CLLocation(latitude: latitude, longitude: longitude) ) { (model) in
                if let model = model {
                    let entry = WeatherEntry(date: Date(), weatherInfo: model)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
        }
    }
    
    private func loadForecastModel(location: CLLocation, completion: @escaping (_ model: ForecastsModel?) -> Void) {
        var forecastModel: ForecastsModel?
        var cityName: String?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { (placeMarks, error) in
            dispatchGroup.leave()
            guard error == nil, let placeMark = placeMarks?.first else {
                return
            }
            
            cityName = placeMark.locality
            
        }
        
        dispatchGroup.enter()
        ApiService.shared.getCurrentWeather(location: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), callback: { (error, model) in
            dispatchGroup.leave()
            if let model = model, error == nil {
                forecastModel = model
                
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            forecastModel?.cityName = cityName
            completion(forecastModel)
        }
    }
}


@main
struct WeatherWidget: Widget {
    private var kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent:  SelectCityIntent.self, provider: WeatherTimeline(), content: { (entry) in
            WeatherEntryView(entry: entry)
        })
        .configurationDisplayName("Weather forecast")
        .description("See the current weather forecast for a location")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

