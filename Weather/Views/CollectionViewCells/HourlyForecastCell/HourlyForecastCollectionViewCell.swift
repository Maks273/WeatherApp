//
//  HourlyForecastCollectionViewCell.swift
//  Weather
//
//  Created by Макс Пайдич on 02.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //MARK: - override

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    
    func configure(model: ForecastModel, timeZone: String) {
        timeLabel.text = (model.date ?? Date()).convertDate(with: "ha", timeZone: timeZone)
        imageView.image = UIImage(named: model.weather.first?.iconName ?? "")
        temperatureLabel.text = "\(Int(model.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º"
    }

}
