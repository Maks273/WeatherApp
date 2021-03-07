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
    var location: CLLocationCoordinate2D?
    
    //MARK: - Initalizer
    
    init(model: GMSAutocompletePrediction) {
        self.fullAddressLine = model.attributedFullText.string
        self.primaryAddressLine = model.attributedPrimaryText.string
        self.placeID = model.placeID
        self.secondaryAddresLine = model.attributedSecondaryText?.string ?? ""
        getLocation(for: model.placeID)
    }
    
    //MARK: - Private methods
    
    private func getLocation(for placeID: String) {
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: GMSAutocompleteSessionToken()) { [weak self] (result, error) in
            guard let sSelf = self else {
                return
            }
            if error == nil {
                sSelf.location = result?.coordinate
            }
        }
    }
    
}
