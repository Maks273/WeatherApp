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
