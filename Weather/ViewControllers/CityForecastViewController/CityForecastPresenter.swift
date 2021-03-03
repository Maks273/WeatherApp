//
//  CityForecastPresenter.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol CityForecastView: class {
    
}

protocol CityForecastPresenter {
    func numberOfRows() -> Int
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

class CityForecastPresenterImplementation: CityForecastPresenter {
    
    
    //MARK: - Variables
    
    private unowned var view: CityForecastView
    private let router: CityForecastRouter
    private let hourlyForecastCellHeight: CGFloat = 140
    private let cellHeight: CGFloat = 70
    private let hourlyForecastIndexPath = IndexPath(row: 0, section: 0)
    
    //MARK: - Initalizer
    
    init(view: CityForecastView, router: CityForecastRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Helper
    
    func numberOfRows() -> Int {
        return 3
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return indexPath == hourlyForecastIndexPath ? hourlyForecastCellHeight : cellHeight
    }
    
    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if indexPath == hourlyForecastIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyTableCell", for: indexPath) as! HourlyForecastTableViewCell
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.backgroundColor = .clear
            return cell
        }
    }
    
}

extension CityForecastPresenterImplementation: HourlyForecastDelegate {
    func numberOfItems() -> Int {
        return 7
    }
    
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCollectionCell", for: indexPath) as! HourlyForecastCollectionViewCell
        return cell
    }
}
