//
//  NextDaysTableViewCell.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class NextDaysTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    
    
    //MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper
    
    func configure(with model: NextDayCellModel) {
        animateContantStackView(isExpanded: model.isExpanded)
        let temperatureMetric = UserDefaultsService.shared.getTemperatureMetric() == TemperatureMetrics.celsius.rawValue ? "C" : "F"
        iconImageView.image = UIImage(named: model.forecastModel.weather.first?.iconName ?? "")
        dateLabel.text = (model.forecastModel.date ?? Date()).convertDate(with: "EEEE, d MMM", timeZone: model.timezone)
        maxTemperatureLabel.text = "\(Int(model.forecastModel.temperature?.max?.rounded(.toNearestOrEven) ?? 0))º\(temperatureMetric)"
        minTemperatureLabel.text = "\(Int(model.forecastModel.temperature?.min?.rounded(.toNearestOrEven) ?? 0))º\(temperatureMetric)"
        humidityLabel.text = "\(Int(model.forecastModel.humidity ?? 0))%"
        uvIndexLabel.text = "\(Int(model.forecastModel.uvi ?? 0))"
        windLabel.text = "\((model.forecastModel.windDegrees ?? 0).windDirectionFromDegrees()) \(model.forecastModel.windSpeed ?? 0) m/s"
        pressureLabel.text = "\(Int(model.forecastModel.pressure ?? 0)) hPa"
    }
    
    
    //MARK: - Private methods
    
    private func animateContantStackView(isExpanded: Bool) {
        self.containerStackView.alpha = 0
        stackViewHeight.constant = isExpanded ? 80 : 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.containerStackView.alpha = isExpanded ? 1 : 0
            self.containerStackView.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.containerStackView.isHidden = !isExpanded
            }
        }
    }
    
}

