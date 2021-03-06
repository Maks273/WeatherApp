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
    private var autoCompleteTableView: UITableView!
    private var autoCompleteHeightConstraint: NSLayoutConstraint!
    private var timer: Timer?
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradiendView()
        configureNavBar()
        setupAutoCompleteTableView()
        configureCityTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
        invalidateTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layer.sublayers?.first?.frame = self.view.layer.bounds
    }
    
    //MARK: - Private methods
    
    private func setupGradiendView() {
        self.view.setupGradientLayer()
    }
    
    private func configureCityTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        textField.delegate = self
    }
    
    //MARK: AutoComplete table view
    
    private func setupAutoCompleteTableView() {
        autoCompleteTableView = UITableView()
        autoCompleteTableView.translatesAutoresizingMaskIntoConstraints = false
        autoCompleteTableView.isHidden = true
        self.view.addSubview(autoCompleteTableView)
        
        autoCompleteHeightConstraint = NSLayoutConstraint(item: autoCompleteTableView!,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .height,
                                                        multiplier: 1,
                                                        constant: 120)
        autoCompleteHeightConstraint.isActive = true
        self.autoCompleteTableView.addConstraint(autoCompleteHeightConstraint)
        
        self.view.addConstraints([
            autoCompleteTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            autoCompleteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            autoCompleteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        configureAutoCompleteTableView()
    }
    
    private func configureAutoCompleteTableView() {
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        autoCompleteTableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        autoCompleteTableView.separatorColor = .lightPurple
        autoCompleteTableView.layer.cornerRadius = 5
        autoCompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
        autoCompleteTableView.tableFooterView = UIView()
    }
    
    //MARK:  Keyboard observer
    
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHide() {
        hideAutoCompleteTable(isHidden: true)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Timer
    
    private func setTimer(searchText: String?) {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerHandler), userInfo: ["text": searchText], repeats: false)
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    @objc private func timerHandler(_ timer: Timer) {
        if let userInfoDict = timer.userInfo as? [String: Any] {
            if let searchText = userInfoDict["text"] as? String {
                presenter.findCity(searchText: searchText)
            }
        }
    }
}

//MARK: - FindCityView

extension FindCityViewController: FindCityView {
    func changeAutoCompleteHeight(constant: CGFloat) {
        if autoCompleteHeightConstraint != nil {
            autoCompleteHeightConstraint.constant = constant
        }
    }
    
    func hideAutoCompleteTable(isHidden: Bool) {
        if autoCompleteTableView != nil {
            autoCompleteTableView.isHidden = isHidden
        }
    }
    
    func reloadAutoCompleteTableView() {
        autoCompleteTableView.reloadData()
    }
}

extension FindCityViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.findCity(searchText: textField.text ?? "")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideAutoCompleteTable(isHidden: true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setTimer(searchText: textField.text)
        return true
    }
}

extension FindCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == autoCompleteTableView {
            presenter.didSelectAutoCompleteCell(at: indexPath)
        }
    }
}

extension FindCityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autoCompleteTableView {
            return presenter.numberOfAutoCompleteRows()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath)
        cell.textLabel?.text = presenter.title(for: indexPath)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
}
