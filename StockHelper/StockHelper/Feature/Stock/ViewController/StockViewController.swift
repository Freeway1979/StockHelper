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
    
    var shouldRefreshTable = false
    
    private enum DataId: String {
        case SECTION_BASIC = "基本情况"
        case CELL_STOCK_NOTE = "股票笔记"
        case CELL_STOCK_DIAGNOSTIC = "股票诊断"
        case CELL_STOCK_TRADE_MONEY = "流通市值"
        case CELL_STOCK_HQ = "股票行情"
        case CELL_STOCK_LIANDONG = "股票联动"
        case CELL_HISTORY_LIANDONG = "历史联动"
        case CELL_STOCK_TAGS = "自定义标签"
        case CELL_STOCK_MEMO = "备忘录"
        
        case SECTION_HOT_BLOCK = "热门板块"
        case SECTION_ZT_IN_120 = "120日涨停数"
        case CELL_ZT_IN_120 = "120日内涨停数"

        case SECTION_STOCK_PROFIT = "盈利数据"
        case SECTION_STOCK_JIEJIN = "解禁数据"
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if self.shouldRefreshTable {
            self.tableView.reloadData()
            self.shouldRefreshTable = false
        }
    }
    
    private func prepareTableViewData() {
        ZKProgressHUD.show()
        let stock:Stock = StockUtils.getStock(by: stockCode)
        self.title = "\(stock.name) \(stock.code)"
        // 基本情况
        var section = TableViewSectionModel()
        section.title = DataId.SECTION_BASIC.rawValue
        section.id = DataId.SECTION_BASIC.rawValue
        var cell:TableViewCellModel
//        cell = TableViewCellModel();
//        cell.data = stockCode
//        cell.id = DataId.CELL_STOCK_NOTE.rawValue
//        cell.title = DataId.CELL_STOCK_NOTE.rawValue
//        cell.accessoryType = .disclosureIndicator
//        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = DataId.CELL_STOCK_DIAGNOSTIC.rawValue
        cell.title = DataId.CELL_STOCK_DIAGNOSTIC.rawValue
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.cellStyle = .value1
        cell.data = stockCode
        cell.id = DataId.CELL_STOCK_TRADE_MONEY.rawValue
        cell.detail = stock.tradeValue.formatMoney
        cell.title = "流通值"
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = DataId.CELL_STOCK_HQ.rawValue
        cell.title = DataId.CELL_STOCK_HQ.rawValue
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.cellStyle = .value1
        cell.id = DataId.CELL_STOCK_LIANDONG.rawValue
        cell.title = DataId.CELL_STOCK_LIANDONG.rawValue
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
    
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.cellStyle = .value1
        cell.id = DataId.CELL_HISTORY_LIANDONG.rawValue
        cell.title = DataId.CELL_HISTORY_LIANDONG.rawValue
        let twimCode:String = stock.extra?.twimCode ?? ""
        if twimCode.count > 1 {
            cell.detail = StockUtils.getStock(by: twimCode).name
        }
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.cellStyle = .value1
        cell.data = stockCode
        cell.id = DataId.CELL_STOCK_TAGS.rawValue
        cell.title = DataId.CELL_STOCK_TAGS.rawValue
        var tags:String = ""
        let extra:StockExtra? = DataCache.getStockExtra(code: stock.code)
        if extra != nil {
            tags = extra!.tags.replacingOccurrences(of: ";", with: " ")
        }
        cell.detail = tags
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        cell = TableViewCellModel();
        cell.data = stockCode
        cell.id = DataId.CELL_STOCK_MEMO.rawValue
        cell.title = DataId.CELL_STOCK_MEMO.rawValue
        cell.accessoryType = .disclosureIndicator
        section.rows.append(cell)
        
        self.tableData.append(section)
        
        //热门板块
        section = TableViewSectionModel()
        section.title = DataId.SECTION_HOT_BLOCK.rawValue
        section.id = DataId.SECTION_HOT_BLOCK.rawValue
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
        section.title = DataId.SECTION_ZT_IN_120.rawValue
        section.id = DataId.SECTION_ZT_IN_120.rawValue
        
        let zts:ZhangTingShuStock? = StockUtils.getZhangTingShuStock(by: stockCode)
        cell = TableViewCellModel();
        cell.cellStyle = .value1
        cell.data = stockCode
        cell.id = DataId.CELL_ZT_IN_120.rawValue
        cell.title = "涨停数"
        cell.detail = zts?.zt ?? "0"
        
        section.rows.append(cell)
        self.tableData.append(section)
        
        //盈利数据
        section = TableViewSectionModel()
        section.title = DataId.SECTION_STOCK_PROFIT.rawValue
        section.id = DataId.SECTION_STOCK_PROFIT.rawValue
        let yingLiStock:YingLiStock? = StockUtils.getYingLiStock(by: stockCode)
        if yingLiStock != nil {
            var desc = "盈利额:\(yingLiStock!.yingliValue.formatMoney)"
            cell = TableViewCellModel();
            cell.data = stockCode
            cell.id = desc
            cell.title = desc
            section.rows.append(cell)
            
            var rise:String = yingLiStock!.yingliRise
            if rise.contains("-") {
                let f:Float = 0 - rise.floatValue
                rise = String(f)
                rise = rise.formatDot2FloatString
                rise = "-\(rise)"
            } else {
                rise = rise.formatDot2FloatString
            }
            cell = TableViewCellModel();
            cell.data = stockCode
            desc = "增长幅度:\(rise)%"
            cell.id = desc
            cell.title = desc
            section.rows.append(cell)
        }
        self.tableData.append(section)
        
        //解禁数据
        section = TableViewSectionModel()
        section.title = DataId.SECTION_STOCK_JIEJIN.rawValue
        section.id = DataId.SECTION_STOCK_JIEJIN.rawValue
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
    
    private func gotoHotBlockViewController(stock: Stock) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Block",bundle: nil)
        var destViewController : HotBlockViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HotBlockViewController") as! HotBlockViewController
        destViewController.liandongStockCode = stock.code
        destViewController.liandongStockName = stock.name
        self.navigationController?.pushViewController(destViewController, animated: true)
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
        var cellModel = sectionModel.rows[indexPath.row]
        let stock:Stock = StockUtils.getStock(by: stockCode)
        if sectionModel.id == DataId.SECTION_BASIC.rawValue {
            if cellModel.id == DataId.CELL_STOCK_NOTE.rawValue {
                let storyboard = UIStoryboard(name: "Stock", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "StockNoteViewController") as! StockNoteViewController
                vc.title = "操盘笔记"
                self.navigationController!.pushViewController(vc, animated: true)
            }
            if cellModel.id == DataId.CELL_STOCK_HQ.rawValue {
                StockUtils.openStockHQPage(code: stock.code, name: stock.name, from: self.navigationController!)
            }
            
            if cellModel.id == DataId.CELL_STOCK_DIAGNOSTIC.rawValue {
                StockUtils.openStockDignosticPage(code: stock.code, name: stock.name, from: self.navigationController!)
            }
                
            if cellModel.id == DataId.CELL_STOCK_LIANDONG.rawValue {
                self.gotoHotBlockViewController(stock: stock)
            }
            
            if cellModel.id == DataId.CELL_STOCK_TAGS.rawValue {
                let vc:StockTagViewController = UIUtils.gotoViewController(storyboard: "Stock", storyboardId: "StockTagViewController", from: self.navigationController!) as! StockTagViewController
                vc.stock = stock
                vc.onComplete = { [unowned self] (tags) in
                    print(tags)
                    cellModel.detail = tags.joined(separator: " ")
                    self.shouldRefreshTable = true
                }
            }
            
            if cellModel.id == DataId.CELL_STOCK_MEMO.rawValue {
                let stockExtra:StockExtra? = StockUtils.getStockExtra(code: stock.code)
                let vc = TextInputViewController.open(initText: stockExtra?.memo, title: "股票备注", from: self.navigationController!)
                vc.onCompleted = { (text) in
                    print(text)
                }
                
            }
        }
    }
}

