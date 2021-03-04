//
//  NextDaysTableViewController.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class NextDaysViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Variables
    
    var presenter: NextDaysPresenter!
    var configurator: NextDaysConfigurator = NextDaysConfiguratorImplementation()
    private let headerHeight: CGFloat = 60
    
    //MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private methods
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.setupGradientLayer()
        tableView.register(UINib(nibName: "NextDaysTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "nextDaysCell")
    }
    
    //MARK: Nav bar
    
    private func configureNavBar() {
        configureTitle()
        setupBackBtn()
    }
    
    private func configureTitle() {
        title = presenter.title()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func setupBackBtn() {
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItems = [backBtn]
    }
    
    @objc private func backBtnPressed() {
        presenter.router.popToViewController()
    }
    
    private func setupHeaderView() -> UIView {
        let view = UIView()
        
        let label = configureHeaderLabel()
        view.addSubview(label)
        
        return view
    }
    
    private func configureHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "Next 7 Days"
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 29)
        label.textColor = .white
        label.frame = CGRect(x: 12, y: 0, width: tableView.frame.width, height: headerHeight)
        return label
    }
    
    
}

//MARK: - NextDaysView

extension NextDaysViewController: NextDaysView {
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
}

//MARK: - UITableViewDataSource

extension NextDaysViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextDaysCell", for: indexPath) as! NextDaysTableViewCell
        if let model = presenter.getModel(for: indexPath) {
             cell.configure(with: model)
             cell.backgroundColor =  model.isExpanded ? UIColor(red: 123/255, green: 159/255, blue: 241/255, alpha: 1) : .clear
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate

extension NextDaysViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.heightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
}
