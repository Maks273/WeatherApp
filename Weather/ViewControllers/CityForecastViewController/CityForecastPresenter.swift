//
//  CityForecastPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol CityForecastView: class {
    func configureCellStyle(for cell: UITableViewCell, hideSeparator: Bool)
}

protocol CityForecastPresenter {
    var router: CityForecastRouter {get}
    
    func numberOfRows() -> Int
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func heightForRow(at indexPath: IndexPath) -> CGFloat
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
    
    //MARK: - Initalizer
    
    init(view: CityForecastView, router: CityForecastRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func numberOfRows() -> Int {
        return 5
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
            return cell
        }else if indexPath == descriptionIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            view.configureCellStyle(for: cell, hideSeparator: false)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "forecastInfoCell", for: indexPath) as! ForecastInfoTableViewCell
            view.configureCellStyle(for: cell, hideSeparator: false)
            return cell
        }
    }
    
}

//MARK: - HourlyForecastDelegate

extension CityForecastPresenterImplementation: HourlyForecastDelegate {
    func numberOfItems() -> Int {
        return 7
    }
    
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCollectionCell", for: indexPath) as! HourlyForecastCollectionViewCell
        return cell
    }
}
