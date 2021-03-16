//
//  CityIntentParamExtention.swift
//  Weather
//
//  Created by Макс Пайдич on 14.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import WidgetKit
import UIKit
import CoreLocation

extension CityParameter {
    
    convenience init(city: CityModel) {
        self.init(identifier: city.id, display: city.name ?? "")
        self.latitude = NSNumber(floatLiteral: city.lat ?? 0)
        self.longitude = NSNumber(floatLiteral: city.lng ?? 0)
    }
    
    static var defaultLocation: CityParameter {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let coordinates = locationManager.location?.coordinate
        return CityParameter(city: CityModel(name: "My Location", timeZone: "", lat: coordinates?.latitude ?? 0, lng: coordinates?.longitude ?? 0, id: ""))
    }
    
    
}
