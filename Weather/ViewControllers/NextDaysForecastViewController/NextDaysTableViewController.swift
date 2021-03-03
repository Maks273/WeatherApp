//
//  NextDaysTableViewController.swift
//  Weather
//
//  Created by Макс Пайдич on 03.03.2021.
//  Copyright © 2021 Макс Пайдич. All rights reserved.
//

import UIKit

class NextDaysTableViewController: UITableViewController {
    
    //MARK: - Variables
    
    var presenter: NextDaysPresenter!
    var configurator: NextDaysConfigurator = NextDaysConfiguratorImplementation()
    private let headerHeight: CGFloat = 60
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
    }
    
    //MARK: - Private methods
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.setupGradientLayer()
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
    
    

    // MARK: - Table view data source & Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRow()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.heightForRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    

}

//MARK: - NextDaysView

extension NextDaysTableViewController: NextDaysView {
    
}