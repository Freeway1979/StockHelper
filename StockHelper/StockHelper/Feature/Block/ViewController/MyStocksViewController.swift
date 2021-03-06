//
//  MyStocksViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

class MyStocksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableData:[TableViewSectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0

        
        
        self.prepareTableViewData()
        self.tableView.reloadData()
    }
    
    private func prepareTableViewData() {
        ZKProgressHUD.show()
        // 1
        var section = TableViewSectionModel()
        section.title = "600604 市北高新"
        section.id = "Section0"
        
        var cell = TableViewCellModel();
        cell.data = ""
        cell.id = "操盘笔记"
        cell.title = "操盘笔记"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        self.tableView.reloadData()
        ZKProgressHUD.dismiss()
    }
    
}


extension MyStocksViewController:UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model:TableViewSectionModel = self.tableData[section]
        
        let headerView = Bundle.main.loadNibNamed("TableHeaderView", owner: self, options: nil)?.first as! TableHeaderView
        headerView.titleLabel.text = model.title
        
        return headerView
    }
}

extension MyStocksViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if cellModel.id == "操盘笔记" {
            let storyboard = UIStoryboard(name: "Stock", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StockNoteViewController") as! StockNoteViewController
            vc.title = "操盘笔记"
            self.navigationController!.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
}


