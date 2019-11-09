//
//  TableCRUDViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class TableCRUDViewController: UIViewController {
    let CELLID = "CELL"
    var tableView:UITableView?
    var tableData:[TableViewSectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let table:UITableView = UITableView(frame: self.view.frame, style: UITableView.Style.plain)
        self.view.addSubview(table)
        self.tableView = table
        // Do any additional setup after loading the view.
        self.registerCells()
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.prepareTableViewData()
    }
    
    //子类override
    func onEdit() -> Bool {
        self.tableView!.isEditing = !self.tableView!.isEditing
        self.tableView!.reloadData()
        return self.tableView!.isEditing
    }
    
    //required
    func buildTableData() -> [TableViewSectionModel] {
        return []
    }
    
    func buildHistoryData() -> TableViewSectionModel? {
        return nil
    }
    
    func registerCells() {
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: CELLID)
    }
    
    var insertItemTitle:String {
        return "新增"
    }
    
    func deleteItem(indexPath:IndexPath, cellModel:TableViewCellModel) {

    }
    //Required
    func insertItem(text:String) -> TableViewCellModel {
        return TableViewCellModel(id: text, title: text, detail: text, cellStyle: .default, accessoryType: .none, data: text)
    }
    
    // Cell
    func dequeueReusableTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,cellModel:TableViewCellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLID, for: indexPath)
        return cell
    }
    
    func updateCell(cell:UITableViewCell, cellModel:TableViewCellModel) {
        cell.accessoryType = cellModel.accessoryType
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.detail
    }
    
    func insertTag(text:String) {
        if text.count > 0 {
            let filted = self.tableData[0].rows.filter { (cell) -> Bool in
                cell.title == text
            }
            if filted.count > 0 {
                return
            }
            let cellModel = self.insertItem(text: text)
            self.tableData[0].rows.append(cellModel)
            self.tableView!.reloadData()
        }
    }
    
    func showAddDataController(indexPath:IndexPath) {
        let alertController = UIAlertController(title: self.insertItemTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (act) in
            let text = alertController.textFields?.first?.text
            if text != nil {
                self.insertTag(text: text!)
            }
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "请输入"
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getCellModel(indexPath: IndexPath) -> TableViewCellModel {
        return self.tableData[indexPath.section].rows[indexPath.row]
    }
    
    private func prepareTableViewData() {
        self.tableData = self.buildTableData()
        let historyData = self.buildHistoryData()
        if historyData != nil && historyData!.rows.count > 0 {
            self.tableData.append(historyData!)
        }
        self.tableView!.reloadData()
    }
    
    private func isLastRow(indexPath:IndexPath) -> Bool {
       return indexPath.row == self.tableData[0].rows.count
    }
    
}


extension TableCRUDViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = self.tableData[section].rows.count
        if self.tableView!.isEditing && section == 0 {
            count = count + 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 &&
            tableView.isEditing && self.isLastRow(indexPath: indexPath) {
            var cell = tableView.dequeueReusableCell(withIdentifier: CELLID)
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: CELLID)
            }
            cell?.textLabel?.text = "添加新数据"
            return cell!
        }
        let cellModel = self.getCellModel(indexPath: indexPath)
        let cell = self.dequeueReusableTableViewCell(tableView, cellForRowAt: indexPath, cellModel: cellModel)
        self.updateCell(cell: cell, cellModel: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return self.tableData[section].title
        }
        return nil
    }
}

extension TableCRUDViewController:UITableViewDelegate {
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView.isEditing == false {
            return .none
        }
        else if self.isLastRow(indexPath: indexPath) {
            return .insert
        } else if indexPath.section == 1 {
            return .insert
        }
        else {
            return .delete
        }
    }
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cellModel = self.getCellModel(indexPath: indexPath)
            self.tableData[indexPath.section].rows.remove(at: indexPath.row)
            self.deleteItem(indexPath: indexPath, cellModel: cellModel)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            if indexPath.section == 1 {
                let cell = self.getCellModel(indexPath: indexPath)
                self.insertTag(text: cell.title)
                return
            }
            self.showAddDataController(indexPath: indexPath)
        }
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
