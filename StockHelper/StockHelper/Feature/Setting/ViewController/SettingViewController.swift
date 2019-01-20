//
//  SettingViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/5.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var settingData:[TableViewSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.prepareTableViewData()
        self.tableView.reloadData()
    }
    
    
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    private func prepareTableViewData() {
        // 1
        var section = TableViewSectionModel()
        section.title = "数据"
        var cell = TableViewCellModel();
        cell.title = "清除本地缓存"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.settingData.append(section)
        
        // 2
        section = TableViewSectionModel()
        section.title = "系统"
        cell = TableViewCellModel();
        cell.title = "关于"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell.title = "账号"
        cell.detail = "我"
        cell.cellStyle = .value1
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.settingData.append(section)
    }
}

extension SettingViewController: ENSideMenuDelegate {
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
}

extension SettingViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingData[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.settingData[indexPath.section].rows[indexPath.row]
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if (cell == nil) {
//            cell = UITableViewCell(style: cellModel.cellStyle, reuseIdentifier: "cell")
//        }
        let cell = UITableViewCell(style: cellModel.cellStyle, reuseIdentifier: "cell")
        cell.accessoryType = cellModel.accessoryType
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.detail
        return cell

    }
    
    
}

extension SettingViewController:UITableViewDelegate {
    
}
