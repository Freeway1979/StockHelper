//
//  ReviewDetailViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/5/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private var date:String {
        get {
            return dateLabel.text ?? ""
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    private var tableData:[TableViewSectionModel] = []
    
    enum ActionType:String {
        case View = "View"
        case Add = "Add"
        case Edit = "Edit"
    }

    var actionType:ActionType = .View
    
    enum SectionType:Int {
        case DaPan = 0
        case ZhuLiuBanKuai = 1
        case JinRiCaoZuo = 2
        case MingRiGuanZhu = 3
        case DaBanQingXu = 4
        
        func description() -> String {
            switch self {
            case .DaPan: return "大盘"
            case .DaBanQingXu: return "打板情绪"
            case .JinRiCaoZuo: return "今日操作"
            case .MingRiGuanZhu: return "明日关注"
            case .ZhuLiuBanKuai: return "主流板块"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if actionType == .Add {
            self.date = DateUtils.dateConvertString(date: Date())
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.prepareTableViewData()
        self.tableView.reloadData()
        
    }
    
    private func prepareTableViewData() {
        // 1
        var section = TableViewSectionModel()
        section.title = SectionType.DaPan.description()
        section.id = section.title
        var cell = TableViewCellModel();
        cell.data = "市场氛围"
        cell.id = "市场氛围"
        cell.title = "市场氛围"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        
        // 2
        section = TableViewSectionModel()
        section.title = SectionType.JinRiCaoZuo.description()
        section.id = section.title
        cell = TableViewCellModel();
        cell.title = "个股操作"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        
        // 3
        section = TableViewSectionModel()
        section.title = SectionType.MingRiGuanZhu.description()
        section.id = section.title
        cell = TableViewCellModel();
        cell.title = "操作策略"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
    }

    

}

extension ReviewDetailViewController:UITableViewDataSource {
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

extension ReviewDetailViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        print(cellModel.title)
//        if sectionModel.id == "Section0" {
//            let fileName = cellModel.data as! String
//            let url = "\(ServiceConfig.baseUrl)/collection/\(fileName)"
//            TextViewController.open(url: url, title: cellModel.title, from: self)
//            //            WebViewController.open(website: url, withtitle:cellModel.title, from: self)
//        }
//        if sectionModel.id == "Section1" {
//            let storyboard = UIStoryboard(name: "Document", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "YanBaoSheDocumentListViewController") as! YanBaoSheDocumentListViewController
//            vc.title = sectionModel.title
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        if sectionModel.id == "Section2" {
//            let storyboard = UIStoryboard(name: "Document", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "WebSiteListViewController") as! WebSiteListViewController
//            vc.title = sectionModel.title
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
}

