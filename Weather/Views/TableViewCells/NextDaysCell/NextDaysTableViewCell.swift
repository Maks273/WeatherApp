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

