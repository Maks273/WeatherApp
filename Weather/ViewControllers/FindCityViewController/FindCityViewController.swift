//
//  FindCityViewController.swift
//  Weather
//
//  Created by Макс Пайдич on 04.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class FindCityViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var presenter: FindCityPresenter!
    let configurator: FindCityConfigurator = FindCityConfiguratorImplementation()
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupGradiendView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layer.sublayers?.first?.frame = self.view.layer.bounds
    }
    
    //MARK: - Private methods
    
    private func setupGradiendView() {
        self.view.setupGradientLayer()
    }
    
    private func configureTableView() {
        
    }
    
}

//MARK: - FindCityView

extension FindCityViewController: FindCityView {
    
}
