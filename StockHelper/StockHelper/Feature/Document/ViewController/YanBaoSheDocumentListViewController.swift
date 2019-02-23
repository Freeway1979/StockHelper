//
//  YanBaoSheDocumentListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/16.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

class YanBaoSheDocumentListViewController: UIViewController {

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
        YanBaoServiceProvider.getYanBaoList(byForce: true) { [weak self] (yanbaos) in
            print(yanbaos)
            DispatchQueue.main.async {
                ZKProgressHUD.dismiss()
                // 1
                var section = TableViewSectionModel()
                section.title = "研报社"
                section.id = "Section0"
                
                for yanbao in yanbaos {
                    var cell = TableViewCellModel();
                    cell.data = yanbao.file
                    cell.id = yanbao.title
                    cell.title = yanbao.title
                    cell.accessoryType = .disclosureIndicator
                    section.rows.append(cell)
                }
                self!.tableData.append(section)
                self!.tableView.reloadData()
                
            }
            
        }
    }
}

extension YanBaoSheDocumentListViewController:UITableViewDataSource {
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

extension YanBaoSheDocumentListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if sectionModel.id == "Section0" {
            //https://github.com/Freeway1979/StockHelper/blob/master/document/image/5G.png
            let url = "\(ServiceConfig.baseImageUrl)/\(cellModel.data ?? "")?raw=true"
            WebViewController.open(website: url , withtitle: cellModel.title, from: self)
        }
    }
    
}
