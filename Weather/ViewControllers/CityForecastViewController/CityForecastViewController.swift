//
//  ViewController.swift
//  Weather
//
//  Created by Макс Пайдич on 25.02.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class CityForecastViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var headerView: TodayForecastHeader!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var presenter: CityForecastPresenter!
    let configurator: CityForecastConfigurator = CityForecastConfiguratorImplementation()
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        setupGradientBgColor()
        configureNavBar()
        configureTableView()
    }
    
    
    //MARK: - Helper
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layer.sublayers?.first?.frame = self.view.layer.bounds
    }
    
    
    //MARK: - Private methods
    
    //MARK: Nav Bar
    
    private func configureNavBar() {
        setupNavButtons()
        setupNavBarStyle()
    }
    
    
    private func setupNavBarStyle() {
        navigationController?.navigationBar.barTintColor = .lightBlue
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupGradientBgColor() {
        self.view.setupGradientLayer()
    }
    
    private func setupNavButtons() {
        setupCurrentLocationBtn()
        setupMenuBtn()
    }
    
    private func setupCurrentLocationBtn() {
        let currentLocationBtn = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(currentLocationBtnPressed))
        currentLocationBtn.tintColor = .white
        navigationItem.rightBarButtonItems = [currentLocationBtn]
    }
    
    @objc private func currentLocationBtnPressed() {
        
    }
    
    private func setupMenuBtn() {
        let menuBtn = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(menuBtnPressed))
        menuBtn.tintColor = .white
        navigationItem.leftBarButtonItems = [menuBtn]
    }
    
    @objc private func menuBtnPressed() {
        
    }
    
    //MARK: TableView
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ForecastInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "forecastInfoCell")
        tableView.tableFooterView = UIView()
        headerView.delegate = self
    }


}

//MARK: - CityForecastView

extension CityForecastViewController: CityForecastView {
    
    func configureCellStyle(for cell: UITableViewCell, hideSeparator: Bool) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: hideSeparator ? 0 : 12, bottom: 0, right: hideSeparator ? 1000 : 12)
        cell.backgroundColor = .clear
    }
}

//MARK: - UITableViewDataSource

extension CityForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.configureCell(tableView, at: indexPath)
    }
    
    
}

//MARK: - UITableViewDelegate

extension CityForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.heightForRow(at: indexPath)
    }
}

extension CityForecastViewController: TodayForecastDelegate {
    func showNextDaysScreen() {
        presenter.router.showNextDaysScreen()
    }
}
