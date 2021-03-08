//
//  ForecastInfoTableViewCell.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class ForecastInfoTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var leftTopLabel: UILabel!
    @IBOutlet weak var leftBottomLabel: UILabel!
    @IBOutlet weak var rightTopLabel: UILabel!
    @IBOutlet weak var rightBottomLabel: UILabel!
    
    //MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper
    
    func configure(models: [ConditionForecast]) {
        if !models.isEmpty {
            leftTopLabel.text = models[0].title
            leftBottomLabel.text = models[0].value
            rightTopLabel.text = models[1].title
            rightBottomLabel.text = models[1].value
        }
    }
    
}
