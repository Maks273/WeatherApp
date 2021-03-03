//
//  HourlyForecastTableViewCell.swift
//  Weather
//
//  Created by Макс Пайдич on 02.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol HourlyForecastDelegate: class {
    func numberOfItems() -> Int
    func configureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}

class HourlyForecastTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    weak var delegate: HourlyForecastDelegate!
    
    //MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper
    
    
    //MARK: - Private methods
    
    private func configureCollectionView() {
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.register(UINib(nibName: "HourlyForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "hourlyCollectionCell")
    }

}

extension HourlyForecastTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 125)
    }
}

extension HourlyForecastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate.configureCell(collectionView, at: indexPath)
    }
    
    
}
