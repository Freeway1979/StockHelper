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
        section.title = "研报社"
        section.id = "Section1"
        cell = TableViewCellModel();
        cell.title = "研报社"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        self.tableData.append(section)
        
        // 3
        section = TableViewSectionModel()
        section.title = "常用网站"
        section.id = "Section2"
        cell = TableViewCellModel();
        cell.title = "常用网站"
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
            let url = "\(ServiceConfig.baseUrl)/collection/\(fileName)"
            TextViewController.open(url: url, title: cellModel.title, from: self)
//            WebViewController.open(website: url, withtitle:cellModel.title, from: self)
        }
        if sectionModel.id == "Section1" {
            let storyboard = UIStoryboard(name: "Document", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "YanBaoSheDocumentListViewController") as! YanBaoSheDocumentListViewController
            vc.title = sectionModel.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if sectionModel.id == "Section2" {
            let storyboard = UIStoryboard(name: "Document", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebSiteListViewController") as! WebSiteListViewController
            vc.title = sectionModel.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

