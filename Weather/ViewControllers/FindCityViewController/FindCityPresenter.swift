//
//  FindCityPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import GooglePlaces

enum TemperatureMetrics: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
    
}

protocol FindCityView: class {
    func changeAutoCompleteHeight(constant: CGFloat)
    func hideAutoCompleteTable(isHidden: Bool)
    func reloadAutoCompleteTableView()
}

protocol FindCityPresenter {
    var router: FindCityRouter {get}
    
    func findCity(searchText: String)
    func numberOfAutoCompleteRows() -> Int
    func title(for indexPath: IndexPath) -> String?
    func didSelectAutoCompleteCell(at indexPath: IndexPath)
    func numberOfCitiesRows() -> Int
    func getTemperaturButtonColor(for tag: Int) -> UIColor
    func changeTemperatureMetric(tag: Int)
}

class FindCityPresenterImplementation: FindCityPresenter {
    
    //MARK: - Variables
    
    unowned var view: FindCityView
    var router: FindCityRouter
    private var autoCompleteDataSource: [GoogleAddressModel] = []
    private let autoCompleteCellHeight: CGFloat = 46
    private let cities: [String] = ["",""]
    
    //MARK: - Initalizer
    
    init(view: FindCityView, router: FindCityRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func findCity(searchText: String) {
        
        autoCompleteDataSource = []
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: GMSAutocompleteSessionToken()) { [weak self] (results, error) in
            
            guard let sSelf = self else { return }
        
            if error == nil {
                results?.forEach{ sSelf.autoCompleteDataSource.append(GoogleAddressModel(model: $0))}
                DispatchQueue.main.async {
                    sSelf.view.changeAutoCompleteHeight(constant: CGFloat(sSelf.autoCompleteDataSource.count) * sSelf.autoCompleteCellHeight)
                    sSelf.view.hideAutoCompleteTable(isHidden: sSelf.autoCompleteDataSource.isEmpty)
                    sSelf.view.reloadAutoCompleteTableView()
                }
            }else {
                NSLog("Error with finding city = \(error?.localizedDescription)")
            }
            
        }
    }
    
    func numberOfAutoCompleteRows() -> Int {
        return autoCompleteDataSource.count
    }
    
    func title(for indexPath: IndexPath) -> String? {
        return indexPath.row < autoCompleteDataSource.count ? autoCompleteDataSource[indexPath.row].fullAddressLine : nil
    }
    
    func didSelectAutoCompleteCell(at indexPath: IndexPath) {
        guard let currentPlaceModel = getPlaceModel(for: indexPath.row) else {
            return
        }
        print(currentPlaceModel)
    }
    
    //MARK: Find city
    
    func numberOfCitiesRows() -> Int {
        return cities.count
    }
    
    func changeTemperatureMetric(tag: Int) {
        UserDefaultsService.shared.saveTemperatureMetric(metric: tag == 0 ? TemperatureMetrics.celsius.rawValue : TemperatureMetrics.fahrenheit.rawValue)
    }
    
    func getTemperaturButtonColor(for tag: Int) -> UIColor {
        return UserDefaultsService.shared.getTemperatureMetric() == TemperatureMetrics.celsius.rawValue && tag == 0 ||
            UserDefaultsService.shared.getTemperatureMetric() == TemperatureMetrics.fahrenheit.rawValue && tag == 1 ? .white : .systemGray5
    }
    
    
    //MARK: - Private methods
    
    private func getPlaceModel(for index: Int) -> GoogleAddressModel? {
        return index < autoCompleteDataSource.count ? autoCompleteDataSource[index] : nil
    }
    
    private func converToCelsius(_ degrees: Double) -> Int {
        return Int((degrees - 32) * (5/9))
    }
    
    private func converToFahrenheit(_ degrees: Double) -> Int {
        return Int(degrees * 1.8 + 32)
    }
    
    
}
