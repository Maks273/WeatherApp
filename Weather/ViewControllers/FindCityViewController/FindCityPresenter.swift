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
    func reloadCityTableView()
    func removeRows(at indexPaths: [IndexPath])
    func reloadCells(at indexPaths: [IndexPath])
    func enableCell(at indexPath: IndexPath)
}

protocol FindCityPresenter {
    var router: FindCityRouter {get}
    
    func viewWillAppear()
    func findCity(searchText: String)
    func numberOfAutoCompleteRows() -> Int
    func title(for indexPath: IndexPath) -> String?
    func didSelectAutoCompleteCell(at indexPath: IndexPath)
    func numberOfCitiesRows() -> Int
    func getTemperaturButtonColor(for tag: Int) -> UIColor
    func changeTemperatureMetric(tag: Int)
    func cityModel(for index: Int) -> CityModel?
    func localTime(for timeZone: String) -> String
    func removeItem(at indexPath: IndexPath)
    func getTemperature(for index: Int) -> String
    func didSelectCityCell(at indexPath: IndexPath)
}

class FindCityPresenterImplementation: FindCityPresenter {
    
    //MARK: - Variables
    
    unowned var view: FindCityView
    var router: FindCityRouter
    private var autoCompleteDataSource: [GoogleAddressModel] = []
    private let autoCompleteCellHeight: CGFloat = 46
    private var cityDataSource: [CityModel] = []
    private var forecastDataSource: [ForecastsModel] = []
    
    //MARK: - Initalizer
    
    init(view: FindCityView, router: FindCityRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func viewWillAppear() {
        loadCityDataSource()
        loadForecastModels()
    }
    
    func findCity(searchText: String) {
        
        autoCompleteDataSource = []
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        
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
    
    //MARK: AutoComplete
    
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
        
        if let location = currentPlaceModel.location {
            ApiService.shared.getCurrentWeather(location: location) { [weak self] (error, result) in
                guard let sSelf = self, let model = result else {
                    print("ERROR = ", error?.localizedDescription)
                    return
                }
                model.cityName = currentPlaceModel.primaryAddressLine
                model.cityId = currentPlaceModel.placeID
                sSelf.router.showCityForecastScreen(with: model, showAsModal: true)
            }
        }
        
    }
    
    //MARK: City
    
    func numberOfCitiesRows() -> Int {
        return cityDataSource.count
    }
    
    func changeTemperatureMetric(tag: Int) {
        UserDefaultsService.shared.saveTemperatureMetric(metric: tag == 0 ? TemperatureMetrics.celsius.rawValue : TemperatureMetrics.fahrenheit.rawValue)
        loadForecastModels()
    }
    
    func getTemperaturButtonColor(for tag: Int) -> UIColor {
        return UserDefaultsService.shared.getTemperatureMetric() == TemperatureMetrics.celsius.rawValue && tag == 0 ||
            UserDefaultsService.shared.getTemperatureMetric() == TemperatureMetrics.fahrenheit.rawValue && tag == 1 ? .white : .systemGray5
    }
    
    func cityModel(for index: Int) -> CityModel? {
        return index < cityDataSource.count ? cityDataSource[index] : nil
    }
    
    func localTime(for timeZone: String) -> String {
        return Date().convertDate(with: "h:mm a", timeZone: timeZone)
    }
    
    func removeItem(at indexPath: IndexPath) {
        cityDataSource.remove(at: indexPath.row)
        saveCityDataSource()
        view.removeRows(at: [indexPath])
    }
    
    func getTemperature(for index: Int) -> String {
        return index < forecastDataSource.count ? "\(Int(forecastDataSource[index].current?.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º" : ""
    }
    
    func didSelectCityCell(at indexPath: IndexPath) {
        if indexPath.row < forecastDataSource.count, forecastDataSource[indexPath.row].current != nil {
            router.showCityForecastScreen(with: forecastDataSource[indexPath.row], showAsModal: false)
        }
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
    
    private func loadCityDataSource() {
        cityDataSource = UserDefaultsService.shared.loadCityDataSource()
        view.reloadCityTableView()
    }
    
    private func saveCityDataSource() {
        UserDefaultsService.shared.saveCityDataSource(cityDataSource)
    }
    
    private func loadForecastModels() {
        fillMockForecastModels()
        for (index, city) in cityDataSource.enumerated() {
            guard let lat = city.lat, let lon = city.lng else {
                return
            }
            loadForecast(for: CLLocationCoordinate2D(latitude: lat, longitude: lon), index: index)
        }
    }
    
    private func fillMockForecastModels() {
        for _ in 0..<cityDataSource.count {
            forecastDataSource.append(ForecastsModel())
        }
    }
    
    private func loadForecast(for location: CLLocationCoordinate2D, index: Int) {
        ApiService.shared.getCurrentWeather(location: location) { [weak self] (error, model) in
            guard let sSelf = self, let model = model else {
                return
            }
            model.cityName = sSelf.cityDataSource[index].name
            sSelf.forecastDataSource[index] = model
            DispatchQueue.main.async {
                sSelf.view.reloadCells(at: [IndexPath(row: index, section: 0)])
                sSelf.view.enableCell(at: IndexPath(row: index, section: 0))
            }
        }
    }
}

