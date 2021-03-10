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
    private var textField: UITextField!
    
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
        presenter.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
        invalidateTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layer.sublayers?.first?.frame = self.view.layer.bounds
        textField.frame = CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.width ?? 0) - 24, height: 30)
    }

    
    //MARK: - Private methods
    
    private func setupGradiendView() {
        self.view.setupGradientLayer()
    }
    
    private func configureCityTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.separatorColor = UIColor(red: 140/255, green: 171/255, blue: 232/255, alpha: 1)
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
        let celsiusBtn = createDegreesBtn(title: "ºC", tag: 0, color: presenter.getTemperaturButtonColor(for: 0))
        let farengateBtn = createDegreesBtn(title: "ºF", tag: 1, color: presenter.getTemperaturButtonColor(for: 1))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [farengateBtn, space, celsiusBtn]
    }
    
    private func createDegreesBtn(title: String, tag: Int, color: UIColor) -> UIBarButtonItem {
        let degressBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeDegreesBtnPressed))
        degressBtn.tag = tag
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
            .foregroundColor: color
        ]
        degressBtn.setTitleTextAttributes(attributes, for: .normal)
        degressBtn.setTitleTextAttributes(attributes, for: .selected)
        
        return degressBtn
    }
    
    @objc private func changeDegreesBtnPressed(sender: UIBarButtonItem) {
        presenter.changeTemperatureMetric(tag: sender.tag)
        changeSelectedTemperaturBtnColor()
        tableView.reloadData()
    }
    
    private func changeSelectedTemperaturBtnColor() {
        navigationItem.rightBarButtonItems?.forEach({ (button) in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "HelveticaNeue-Medium", size: 20)!,
                .foregroundColor: presenter.getTemperaturButtonColor(for: button.tag)
            ]
            button.setTitleTextAttributes(attributes, for: .normal)
        })
    }
    
    private func setupSearchTextField() {
        textField = UITextField()
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "City name"
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        //textField.frame = CGRect(x: 12, y: 0, width: (navigationController?.navigationBar.frame.width ?? 0) - 24, height: 30)
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
            autoCompleteTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            autoCompleteTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
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
    
    func reloadCityTableView() {
        tableView.reloadData()
    }
    
    func removeRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func reloadCells(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func enableCell(at indexPath: IndexPath) {
        if indexPath.row < tableView.visibleCells.count {
            tableView.visibleCells[indexPath.row].isUserInteractionEnabled = true
        }
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
        tableView == autoCompleteTableView ? presenter.didSelectAutoCompleteCell(at: indexPath) : presenter.didSelectCityCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .destructive, title: "") { (action, view, finished) in
            self.presenter.removeItem(at: indexPath)
        }
        swipe.image = UIImage(systemName: "xmark.bin.fill")
        return UISwipeActionsConfiguration(actions: [swipe])
    }
}

extension FindCityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == autoCompleteTableView ? presenter.numberOfAutoCompleteRows() : presenter.numberOfCitiesRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == autoCompleteTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath)
            cell.textLabel?.text = presenter.title(for: indexPath)
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
            cell.textLabel?.textAlignment = .left
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "findCityCell", for: indexPath) as! FindCityTableViewCell
        cell.delegate = self
        cell.isUserInteractionEnabled = false
        if let model = presenter.cityModel(for: indexPath.row) {
            cell.configure(model: model, indexPath: indexPath)
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension FindCityViewController: FindCityCellDelegate {
    func setTemperature(for indexPath: IndexPath) -> String {
        return presenter.getTemperature(for: indexPath.row)
    }
    
    func localTime(for timeZone: String) -> String {
        return presenter.localTime(for: timeZone)
    }
}
