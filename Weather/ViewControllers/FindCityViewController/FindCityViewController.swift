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
        configureNavBar()
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
    
    //MARK: Nav bar
    
    private func configureNavBar() {
        setupBackBtn()
        setupChangeDegreesBtn()
        setupSearchTextField()
    }
    
    private func setupBackBtn() {
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItems = [backBtn]
    }
    
    @objc private func backBtnPressed() {
        presenter.router.popToViewController()
    }
    
    private func setupChangeDegreesBtn() {
        let celsiusBtn = createDegreesBtn(title: "ºC", tag: 0, color: .white)
        let farengateBtn = createDegreesBtn(title: "ºF", tag: 1, color: .systemGray5)
        navigationItem.rightBarButtonItems = [farengateBtn, celsiusBtn]
    }
    
    private func createDegreesBtn(title: String, tag: Int, color: UIColor) -> UIBarButtonItem {
        let degressBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeDegreesBtnPressed))
        degressBtn.tag = tag
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
            .foregroundColor: color
        ]
        degressBtn.setTitleTextAttributes(attributes, for: .normal)
        
        return degressBtn
    }
    
    @objc private func changeDegreesBtnPressed(sender: UIBarButtonItem) {
        
    }
    
    private func setupSearchTextField() {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "City, zip code"
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.frame = CGRect(x: 12, y: 0, width: navigationController?.navigationBar.frame.width ?? 0 - 24, height: 30)
        navigationItem.titleView = textField
    }
    
}

//MARK: - FindCityView

extension FindCityViewController: FindCityView {
    
}
