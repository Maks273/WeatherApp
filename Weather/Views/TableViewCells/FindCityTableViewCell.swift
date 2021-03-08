//
//  FindCityTableViewCell.swift
//  Weather
//
//  Created by Макс Пайдич on 06.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

protocol FindCityCellDelegate: class {
    func localTime(for timeZone: String) -> String
    func setTemperature(for indexPath: IndexPath) -> String
}

class FindCityTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //MARK: - Variables
    
    unowned var delegate: FindCityCellDelegate!
    
    //MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Helper
    
    func configure(model: CityModel, indexPath: IndexPath) {
        nameLabel.text = model.name
        timeLabel.text = delegate.localTime(for: model.timeZone ?? "")
        temperatureLabel.text = delegate.setTemperature(for: indexPath)
    }
    
}
