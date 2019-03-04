//
//  WebSiteListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/3/3.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit
import ZKProgressHUD

class WebSiteListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tableData:[TableViewSectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.prepareTableViewData()
        self.tableView.reloadData()
    }
    
    private func getDataFromServer() -> [ThirdWebSite] {
        let url = "\(ServiceConfig.baseUrl)/website.json"
        let data = try? Data(contentsOf: URL(string: url)!)
        let json = String(data: data!, encoding: String.Encoding.utf8)
        let rs:[ThirdWebSite] = json?.json2Objects() ?? []
        return rs
    }
    
    private func prepareTableViewData() {
        ZKProgressHUD.show()
        let websiteList = getDataFromServer()
        DispatchQueue.main.async {
            // 1
            var section = TableViewSectionModel()
            section.title = "常用网站"
            section.id = "Section0"
            
            for website in websiteList {
                var cell = TableViewCellModel();
                cell.data = website.url
                cell.id = website.title
                cell.title = website.title
                cell.accessoryType = .disclosureIndicator
                section.rows.append(cell)
            }
            self.tableData.append(section)
            self.tableView.reloadData()
            ZKProgressHUD.dismiss()
        }
    }
}

extension WebSiteListViewController:UITableViewDataSource {
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

extension WebSiteListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if sectionModel.id == "Section0" {
            let url = cellModel.data as! String
            WebViewController.open(website: url , withtitle: cellModel.title, from: self)
        }
    }
    
}

