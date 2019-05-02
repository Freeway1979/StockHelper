//
//  StockViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

class StockViewController: UIViewController {
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
    
    private func prepareTableViewData() {
        ZKProgressHUD.show()
        // Get My Stocks 获取我的自选股
        // 1
        var section = TableViewSectionModel()
        section.title = "002668 奥马电器"
        section.id = "Section0"
        
        var cell = TableViewCellModel();
        cell.data = ""
        cell.id = "股票笔记"
        cell.title = "股票笔记"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        self.tableView.reloadData()
        ZKProgressHUD.dismiss()
    }
    
}


extension StockViewController:UITableViewDataSource {
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

extension StockViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Stock", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StockNoteViewController") as! WebViewController
            vc.title = cellModel.title
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}

