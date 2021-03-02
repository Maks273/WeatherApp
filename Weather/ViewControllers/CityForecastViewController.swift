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
    
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBgColor()
        configureNavBar()
    }
    
    
    //MARK: - Helper
    
    
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
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        let topColor = UIColor.lightBlue.cgColor
        let bottomColor = UIColor.lightPurple.cgColor
        
        gradientLayer.colors = [topColor,bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.frame
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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


}

