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
    var stockCode:String = ""
    
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
        let stock:Stock = StockUtils.getStock(by: stockCode)
        self.title = "\(stock.name) \(stock.code)"
        // 基本情况
        var section = TableViewSectionModel()
        section.title = "基本情况"
        section.id = "SectionBasic"
        
        var cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = "股票笔记"
        cell.title = "股票笔记"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = "股票行情"
        cell.title = "股票行情"
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        self.tableData.append(section)
        
        //热门板块
        section = TableViewSectionModel()
        section.title = "热门板块"
        section.id = "SectionHotBlock"
        // 看看是否在前十大热门板块中
        let blocks:[String] = DataCache.getTopBlockNamesForStock(stock: stock)
        for block in blocks {
            cell = TableViewCellModel();
            cell.data = stockCode
            cell.id = block
            cell.title = block
            section.rows.append(cell)
        }
        self.tableData.append(section)
        
        //120日内涨停数
        section = TableViewSectionModel()
        section.title = "120日内涨停数"
        section.id = "SectionZTS"
        
        let zts:ZhangTingShuStock? = StockUtils.getZhangTingShuStock(by: stockCode)
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = "120日涨停数"
        cell.title = "0"
        if zts != nil {
          cell.title = zts!.zt
        }
        section.rows.append(cell)
        self.tableData.append(section)
        
        //盈利数据
        section = TableViewSectionModel()
        section.title = "盈利数据"
        section.id = "SectionJieJin"
        let yingLiStock:YingLiStock? = StockUtils.getYingLiStock(by: stockCode)
        if yingLiStock != nil {
            cell = TableViewCellModel();
            cell.data = stockCode
            var rise:String = yingLiStock!.yingliRise
            if rise.contains("-") {
                let f:Float = 0 - rise.floatValue
                rise = String(f)
                rise = rise.formatDot2FloatString
                rise = "-\(rise)"
            } else {
                rise = rise.formatDot2FloatString
            }
            
            let desc = "流通值:\(yingLiStock!.tradeValue.formatMoney) 盈利:\(yingLiStock!.yingliValue.formatMoney) \(rise)%"
            cell.id = desc
            cell.title = desc
            section.rows.append(cell)
        }
        self.tableData.append(section)
        
        //解禁数据
        section = TableViewSectionModel()
        section.title = "解禁数据"
        section.id = "SectionJieJin"
        let jiejinStocks:[JieJinStock] = StockUtils.getJieJinStocks(by: stockCode)
        for item in jiejinStocks {
            cell = TableViewCellModel();
            cell.data = item.date
            cell.id = "\(item.date) 比例:\(item.ratio.formatDot2FloatString)% 金额:\(item.money.formatMoney)"
            cell.title = "\(item.date) 比例:\(item.ratio.formatDot2FloatString)% 金额:\(item.money.formatMoney)"
            section.rows.append(cell)
        }
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionModel = self.tableData[section]
        return sectionModel.title
    }
    
}

extension StockViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = self.tableData[indexPath.section]
        let cellModel = sectionModel.rows[indexPath.row]
        if sectionModel.id == "SectionBasic" {
            if cellModel.id == "股票笔记" {
                let storyboard = UIStoryboard(name: "Stock", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "StockNoteViewController") as! StockNoteViewController
                vc.title = "操盘笔记"
                self.navigationController!.pushViewController(vc, animated: true)
            }
            if cellModel.id == "股票行情" {
                let stock:Stock = StockUtils.getStock(by: stockCode)
                StockUtils.openStockHQPage(code: stock.code, name: stock.name, from: self.navigationController!)
            }
        }
    }
}

