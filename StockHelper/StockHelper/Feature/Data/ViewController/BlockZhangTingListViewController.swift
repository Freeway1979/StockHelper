//
//  BlockZhangTingListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import ZKProgressHUD

class BlockZhangTingListViewController: UIViewController {
    struct DataItem {
        var title:String
        var stocks:[ZhangTingStock]
    }
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cellID:String = "ZhangTingStockTableViewCell"
    public var dates:[String] = []
    public var blockName:String = ""
    var date:String = Date().formatWencaiDateString()
    var dataList:[DataItem] = []
    var dragonCode:String?
    let rightBarButtonTitles = ["全部","组合","板块"]
    enum BarButtonTitleType:Int {
        case BANKUAI = 0
        case ALL
        case ZUHE
    }
    var barButtonTitleType: BarButtonTitleType = .BANKUAI
    var showAllStocks: Bool {
        return barButtonTitleType != .BANKUAI
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragonCode = DataCache.marketDragon?.code
        self.updateRightBarButtonTitle()
        self.prepareData()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UINib(nibName: "ZhangTingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "ZhangTingStockTableViewCell")
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.reloadData()
    }
    
    @IBAction func onRightBarButtonClicked(_ sender: UIBarButtonItem) {
        self.nextType()
        self.updateRightBarButtonTitle()
        self.prepareData()
        self.reloadData()
    }
    func nextType() {
        var type = barButtonTitleType.rawValue + 1
        if type == 3 {
            type = 0
        }
        barButtonTitleType = BarButtonTitleType(rawValue: type)!
    }
    func updateRightBarButtonTitle() {
        rightBarButton.title = rightBarButtonTitles[barButtonTitleType.rawValue]
        var title = self.blockName
        if barButtonTitleType == .ALL {
            title = "全部板块"
        } else if barButtonTitleType == .ZUHE {
            title = "概念组合"
        }
        self.navigationController?.title = title
        self.title = title
    }
    
    func prepareData() {
        var dataList:[ZhangTingStock] = []
        if self.showAllStocks {
            let zts:ZhangTingStocks? = DataCache.getZhangTingStocks(by: self.date)
            let list: [ZhangTingStock] = zts?.stocks ?? []
            dataList.append(contentsOf: list)
        } else {
            self.dates.forEach { (date) in
                let zts:ZhangTingStocks? = DataCache.getZhangTingStocks(by: date)
                let list = zts?.stocks.filter({ (stock) -> Bool in
                        stock.gnList.contains(self.blockName)
                    }) ?? []
                dataList.append(contentsOf: list)
            }
        }
        // 去重
        let set = Set(arrayLiteral: dataList)
        dataList = set.flatMap({ $0 })
        //连板数分类
        var dict:[String:[ZhangTingStock]] = [:]
        dataList.forEach { (stock) in
            let key = "\(stock.zhangting)"
            var stocks:[ZhangTingStock] = dict[key] ?? []
            stocks.append(stock)
            dict[key] = stocks
        }
        var data:[DataItem] = []
        // Sort Dictionary
        for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
            var stocks = v
            // 排序
            stocks.sort { (lhs, rhs) -> Bool in
                if (lhs.zhangting > rhs.zhangting) {
                    return true
                } else if (lhs.zhangting < rhs.zhangting) {
                    return false
                }
                let s1 = StockUtils.getStock(by: lhs.code)
                let s2 = StockUtils.getStock(by: rhs.code)
                return s1.tradeValue.floatValue <= s2.tradeValue.floatValue
            }
            let item = DataItem(title:k, stocks: stocks)
            data.append(item)
        }
        data.sort { (lhs, rhs) -> Bool in
            lhs.title > rhs.title
        }
        self.dataList = data
    }
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
    }
    
}

extension BlockZhangTingListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let s = self.dataList[indexPath.section].stocks[indexPath.row]
        let stock = StockUtils.getStock(by: s.code)
        let name = stock.name
        let view:ZhangTingStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ZhangTingStockTableViewCell
        var title:String = ""
        var line1:String = ""
        var line2:String = ""
        var badge:String = ""
        line1 = "\(stock.code) 流通值:\(stock.tradeValue.formatMoney)"
        let yingli = stock.yingliStr
        if yingli != nil {
            line1 = "\(line1) \(yingli!)"
        }
        let jiejin = stock.jiejinStr
        if jiejin != nil {
            line1 = "\(line1) \(jiejin!)"
        }
        let hotblocksCount = DataCache.getTopBlockNamesForStock(stock: stock).count
        
        line2 = "封单额\(s.ztMoney.formatMoney) 封成比:\(s.ztRatioBills.formatDot2FloatString) 封流比:\(s.ztRatioMoney.formatDot2FloatString)"
        badge = s.ztBanType
        
        if hotblocksCount > 0 {
            title = "\(title) 热门概念:\(hotblocksCount)"
        }
        if dragonCode != nil && stock.code != dragonCode {
           let sameblocks = StockUtils.getSameBlockNames(this: stock.code, that: dragonCode!)
            if sameblocks.count > 0 {
                title = "\(title) 龙头概念:\(sameblocks.count)"
            }
        }
        view.applyModel(name: name, title: title, line1: line1, line2: line2, badge: badge)
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.dataList[section]
        let title = "\(item.title)连板"
        return title
    }
}

extension BlockZhangTingListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = self.dataList[indexPath.section].stocks[indexPath.row]
        StockUtils.gotoStockViewController(code: s.code, from: self.navigationController!)
    }
}

