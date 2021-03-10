//
//  NextDaysPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol NextDaysView: class {
    func reloadRows(at indexPaths: [IndexPath])
}

protocol NextDaysPresenter {
    var router: NextDaysRouter {get}
    
    func viewDidLoad()
    func title() -> String
    func numberOfRow() -> Int
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
    func getModel(for indexPath: IndexPath) -> NextDayCellModel?
}

struct NextDayCellModel {
    var isExpanded: Bool
    var forecastModel: ForecastModel
    var timezone: String
}

class NextDaysPresenterImplementation : NextDaysPresenter {
    
    //MARK: - Variables
    
    unowned let view: NextDaysView
    let router: NextDaysRouter
    var model: ForecastsModel?
    private var dataSource: [NextDayCellModel] = []
    
    //MARK: - Initalizer
    
    init(view: NextDaysView, router: NextDaysRouter, model: ForecastsModel) {
        self.view = view
        self.router = router
        self.model = model
    }
    
    //MARK: - Helper
    
    func viewDidLoad() {
        fillDataSource()
    }
    
    func title() -> String {
        return model?.cityName ?? ""
    }
    
    func numberOfRow() -> Int {
        return dataSource.count
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.row].isExpanded ? 190 : 210/2
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        changeExpandedStatus(for: indexPath)
    }
    
    func getModel(for indexPath: IndexPath) -> NextDayCellModel? {
        return indexPath.row < dataSource.count ? dataSource[indexPath.row] : nil
    }
    
    //MARK: - Private methods
    
    private func fillDataSource() {
        guard let dailyForecasts = model?.daily, !dailyForecasts.isEmpty else {
            return
        }
        
        dailyForecasts.forEach { (model) in
            let cellModel = NextDayCellModel(isExpanded: false, forecastModel: model, timezone: self.model?.timezone ?? "")
            self.dataSource.append(cellModel)
        }
    }
    
    private func changeExpandedStatus(for indexPath: IndexPath) {
        if indexPath.row < dataSource.count {
            dataSource[indexPath.row].isExpanded.toggle()
            view.reloadRows(at: [indexPath])
        }
    }
}
