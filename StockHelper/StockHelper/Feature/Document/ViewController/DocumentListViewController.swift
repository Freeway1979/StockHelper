//
//  DocumentListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/1.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class DocumentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tableData:[TableViewSectionModel] = []
    
    @IBAction func onMenuButtonClicked(_ sender: UIBarButtonItem) {
         toggleSideMenuView()
    }
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
        section.title = "A股雷区"
        section.id = "Section0"
        var cell = TableViewCellModel();
        cell.data = "2018年A股问题公司清单.txt"
        cell.id = "2018年A股问题公司清单"
        cell.title = "2018年A股问题公司清单"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        
        // 2
        section = TableViewSectionModel()
        section.title = "前方高能"
        cell = TableViewCellModel();
        cell.title = "建设中。。。"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
       
        
        self.tableData.append(section)
    }
}

extension DocumentListViewController: ENSideMenuDelegate {
    
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

extension DocumentListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.tableData[indexPath.section].rows[indexPath.row]
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

extension DocumentListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if sectionModel.id == "Section0" {
            let fileName = cellModel.data as! String
            let url = "https://raw.githubusercontent.com/Freeway1979/StockHelper/master/document/collection/\(fileName)"
            TextViewController.open(url: url, title: cellModel.title, from: self)
//            WebViewController.open(website: url, withtitle:cellModel.title, from: self)
        }
    }
    
}
