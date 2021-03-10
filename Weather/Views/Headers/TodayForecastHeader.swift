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
    func changeForecastModel(isToday: Bool)
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
    @IBOutlet var indicatorsView: [UIView]!
    
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
    
    func configure(model: ForecastsModel, isToday: Bool) {
        guard let currentForecast = model.current, model.daily.count > 1 else {
            return
        }
        let forecastModel = isToday ? currentForecast : model.daily[1]
        
        tempLabel.text = "\(Int(forecastModel.currentTemperature?.rounded(.toNearestOrEven) ?? 0))º"
        dateLabel.text = (forecastModel.date ?? Date()).convertDate(with: "MMM d, yyyy", timeZone: model.timezone ?? "")
        imageView.image = UIImage(named: forecastModel.weather.first?.iconName ?? "")
        cityLabel.text = model.cityName
        highTempLabel.text = "H: \(Int(forecastModel.temperature?.max?.rounded(.toNearestOrEven) ?? 0))"
        lowTempLabel.text = "L: \(Int(forecastModel.temperature?.min?.rounded(.toNearestOrEven) ?? 0))"
        dayLabel.text = isToday ? "Today" : "Tomorrow"
        containerView.isHidden = false
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextDaysBtnPressed(_ sender: Any) {
        delegate?.showNextDaysScreen()
    }
    
    @IBAction func changeDayBtnPressed(_ sender: UIButton) {
        delegate?.changeForecastModel(isToday: sender.tag == 0)
        setCurrentIndicator(tag: sender.tag)
    }
    
    //MARK: - Private methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TodayForecastHeader", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    private func setCurrentIndicator(tag: Int) {
        for (index, view) in indicatorsView.enumerated() {
            view.isHidden = index != tag
        }
    }
    
}
