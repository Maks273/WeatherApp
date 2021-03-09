//
//  TodayForecastHeader.swift
//  Weather
//
//  Created by Макс Пайдич on 02.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol TodayForecastDelegate: class {
    func showNextDaysScreen()
}

class TodayForecastHeader: UIView {

    //MARK: - IBOutlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    //MARK: - Variables
    
    weak var delegate: TodayForecastDelegate?
    
    //MARK: - Initalizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Helper
    
    func configure(model: ForecastsModel) {
        guard let currentForecast = model.current else {
            return
        }
        tempLabel.text = "\(Int(currentForecast.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º"
        dateLabel.text = (currentForecast.date ?? Date()).convertDate(with: "MMM d, yyyy", timeZone: model.timezone ?? "")
        imageView.image = UIImage(named: currentForecast.weather.first?.iconName ?? "")
        cityLabel.text = model.cityName
        highTempLabel.text = "H: \(Int(model.daily.first?.temperature?.max?.rounded(.toNearestOrEven) ?? 0))"
        lowTempLabel.text = "L: \(Int(model.daily.first?.temperature?.min?.rounded(.toNearestOrEven) ?? 0))"
        containerView.isHidden = false
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextDaysBtnPressed(_ sender: Any) {
        delegate?.showNextDaysScreen()
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TodayForecastHeader", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
}
