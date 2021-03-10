//
//  CityForecastPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

protocol CityForecastView: class {
    func configureCellStyle(for cell: UITableViewCell, hideSeparator: Bool)
    func configureHeader(model: ForecastsModel, isToday: Bool)
    func reloadTableView()
}

protocol CityForecastPresenter {
    var router: CityForecastRouter {get}
    
    func viewWillAppear()
    func numberOfRows() -> Int
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func setForecastsModel(_ model: ForecastsModel)
    func addCity()
    func loadForecast(for location: CLLocationCoordinate2D)
    func loadCityName(by location: CLLocation)
    func changeForecastModel(isToday: Bool)
}

struct ConditionForecast {
    var title: String
    var value: String
}

class CityForecastPresenterImplementation: CityForecastPresenter {
    
    
    //MARK: - Variables
    
    let router: CityForecastRouter
    private unowned var view: CityForecastView
    private let hourlyForecastCellHeight: CGFloat = 140
    private let descriptionCellHeight: CGFloat = 70
    private let forecastInfoCellHeight: CGFloat = 55
    private let hourlyForecastIndexPath = IndexPath(row: 0, section: 0)
    private let descriptionIndexPath = IndexPath(row: 1, section: 0)
    private var model: ForecastsModel?
    private var conditionsDataSource: [[ConditionForecast]] = [[]]
    private var currentCityModel: CityModel?
    private var cityName: String?
    private var isToday: Bool = true
    private var hourlyForecastDataSource: [ForecastModel] = []
    
    //MARK: - Initalizer
    
    init(view: CityForecastView, router: CityForecastRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func viewWillAppear() {
        fillViews()
    }
    
    func numberOfRows() -> Int {
        return model == nil ? 0 : conditionsDataSource.count + 2
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if indexPath == hourlyForecastIndexPath {
            return hourlyForecastCellHeight
        }else if indexPath == descriptionIndexPath {
            return descriptionCellHeight
        }else {
            return forecastInfoCellHeight
        }
    }
    
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if indexPath == hourlyForecastIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyTableCell", for: indexPath) as! HourlyForecastTableViewCell
            view.configureCellStyle(for: cell, hideSeparator: true)
            cell.delegate = self
            cell.hourlyForecastCollectionView.reloadData()
            return cell
        }else if indexPath == descriptionIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.configure(title: descriptionCellTitle(partDay: isToday ? "Today" : "Tomorrow"))
            view.configureCellStyle(for: cell, hideSeparator: false)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "forecastInfoCell", for: indexPath) as! ForecastInfoTableViewCell
            cell.configure(models: getInfoModels(for: indexPath.row - 2))
            view.configureCellStyle(for: cell, hideSeparator: false)
            return cell
        }
    }
    
    func setForecastsModel(_ model: ForecastsModel) {
        self.model = model
    }
    
    func addCity() {
        var cityDataSource = UserDefaultsService.shared.loadCityDataSource()
        if let currentCityModel = currentCityModel {
            if let cityID = currentCityModel.id, !cityDataSource.contains(where: {$0.id == cityID}) {
                cityDataSource.append(currentCityModel)
                UserDefaultsService.shared.saveCityDataSource(cityDataSource)
            }
        }
    }
    
    func loadForecast(for location: CLLocationCoordinate2D) {
        ApiService.shared.getCurrentWeather(location: location) { [weak self] (error, model) in
            guard let sSelf = self, let model = model else {
                return
            }
            sSelf.model = model
            sSelf.model?.cityName = sSelf.cityName
            DispatchQueue.main.async {
                sSelf.fillViews()
            }
        }
    }
    
    func loadCityName(by location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            guard let sSelf = self, error == nil, let placeMark = placeMarks?.first else {
                return
            }
            sSelf.cityName = placeMark.locality
            sSelf.model?.cityName = placeMark.locality
            DispatchQueue.main.async {
                if let model = sSelf.model {
                    sSelf.view.configureHeader(model: model, isToday: sSelf.isToday)
                }
            }
        }
    }
    
    func changeForecastModel(isToday: Bool) {
        self.isToday = isToday
        fillViews()
    }
    
    //MARK: - Private methods
    
    private func fillViews() {
        guard let model = model else {
            return
        }
        
        view.configureHeader(model: model, isToday: isToday)
        fillConditionsDataSource()
        configureHourlyDataSource()
        view.reloadTableView()
        currentCityModel = CityModel(name: model.cityName, timeZone: model.timezone, lat: model.lat, lng: model.lon, id: model.cityId)
    }
    
    private func fillConditionsDataSource() {
        guard let currentForecast = self.model?.current, let timeZone = model?.timezone, let model = model else {
            return
        }
        
        let forecastModel = isToday ? currentForecast : model.daily[1]
        
        conditionsDataSource = [
            [ConditionForecast(title: "SUNRICE", value: (forecastModel.sunrise ?? Date()).convertDate(with: "h:mm a", timeZone: timeZone)),
             ConditionForecast(title: "SUNSET", value: (forecastModel.sunset ?? Date()).convertDate(with: "h:mm a", timeZone: timeZone))],
            [ConditionForecast(title: "HUMIDITY", value: "\(forecastModel.humidity ?? 0)%"),
             ConditionForecast(title: "PRESSURE", value: "\(forecastModel.pressure ?? 0) hPa")],
            [ConditionForecast(title: "FEELS LIKE", value: "\(Int(forecastModel.feelsLikeCurrent?.rounded(.toNearestOrEven) ?? 0))º"),
             ConditionForecast(title: "VISIBILITY", value: "\((forecastModel.visibility ?? 0)/1000) km")],
            [ConditionForecast(title: "UV INDEX", value: "\(forecastModel.uvi ?? 0)"),
             ConditionForecast(title: "WIND", value: "\(windDirectionFromDegrees(forecastModel.windDegrees ?? 0)) \(forecastModel.windSpeed ?? 0) m/s")]
        ]
        
    }
    
    private func descriptionCellTitle(partDay: String) -> String {
        let forecastModel = isToday ? model?.current : model?.daily[1]
        return "\(partDay): \(forecastModel?.weather.first?.description?.capitalized ?? ""). The high will be \(Int(forecastModel?.temperature?.max?.rounded(.toNearestOrEven) ?? 0))º, the low will be \(Int(forecastModel?.temperature?.night?.rounded(.toNearestOrEven) ?? 0))º."
    }
    
    private func getInfoModels(for index: Int) -> [ConditionForecast] {
        return index < conditionsDataSource.count ? conditionsDataSource[index] : []
    }
    
    private func windDirectionFromDegrees(_ degrees : Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
    
    private func getHourlyModel(for index: Int) -> ForecastModel? {
        return index < hourlyForecastDataSource.count ? hourlyForecastDataSource[index] : nil
    }
    
    private func configureHourlyDataSource() {
        guard let model = model, !isToday, let midnightIndex = midnightIndex(in: model) else {
            hourlyForecastDataSource = self.model?.hourly ?? []
            return
        }
        
        var tempDataSource: [ForecastModel] = []
        
        for (index, model) in model.hourly.enumerated() {
            if index >= midnightIndex {
                tempDataSource.append(model)
            }
        }

        hourlyForecastDataSource = tempDataSource
    }
    
    private func midnightIndex(in model: ForecastsModel) -> Int? {
        for (index, hourModel) in model.hourly.enumerated() {
            let dateString = (hourModel.date ?? Date()).convertDate(with: "ha", timeZone: model.timezone ?? "")
            if dateString == "12AM" {
                return index
            }
        }
        return nil
    }
    
}

//MARK: - HourlyForecastDelegate

extension CityForecastPresenterImplementation: HourlyForecastDelegate {
    func numberOfItems() -> Int {
        return hourlyForecastDataSource.count
    }
    
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCollectionCell", for: indexPath) as! HourlyForecastCollectionViewCell
        if let model = getHourlyModel(for: indexPath.item), let timeZone = self.model?.timezone {
            cell.configure(model: model, timeZone: timeZone)
        }
        return cell
    }
}
