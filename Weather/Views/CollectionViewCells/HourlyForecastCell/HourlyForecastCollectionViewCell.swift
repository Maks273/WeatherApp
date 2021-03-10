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
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - override

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper
    
    func configure(model: ForecastModel, timeZone: String, isFirst: Bool) {
        changeStyle(isFirst: isFirst)
        timeLabel.text = (model.date ?? Date()).convertDate(with: "ha", timeZone: timeZone)
        imageView.image = UIImage(named: model.weather.first?.iconName ?? "")
        temperatureLabel.text = "\(Int(model.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º"
    }

    //MARK: - Private methods
    
    private func changeStyle(isFirst: Bool) {
        containerView.backgroundColor = isFirst ? .white : UIColor(red: 85/255, green: 118/255, blue: 235/255, alpha: 1)
        timeLabel.textColor = isFirst ? .black : .white
        temperatureLabel.textColor = isFirst ? .black : .white
    }
}
