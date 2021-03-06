//
//  GoogleAddressModel.swift
//  Weather
//
//  Created by Макс Пайдич on 05.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import Foundation
import GooglePlaces

class GoogleAddressModel {
   
    // MARK: - Properties
    
    var fullAddressLine = ""
    var primaryAddressLine = ""
    var secondaryAddresLine = ""
    var placeID = ""
    
    //MARK: - Initalizer
    
    init(model: GMSAutocompletePrediction) {
        self.fullAddressLine = model.attributedFullText.string
        self.primaryAddressLine = model.attributedPrimaryText.string
        self.placeID = model.placeID
        self.secondaryAddresLine = model.attributedSecondaryText?.string ?? ""
    }
    
}
