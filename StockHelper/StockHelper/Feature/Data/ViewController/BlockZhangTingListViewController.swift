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
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cellID:String = "ZhangTingStockTableViewCell"
    public var dates:[String] = []
    public var blockName:String = ""
    var date:String = Date().formatWencaiDateString()
    var dataList:[ZhangTingStock] = []
    var dragonCode:String?
    var showAllStocks: Bool {
        get {
            return rightBarButton.title == "板块"
        }
        set {
            rightBarButton.title = newValue ? "板块":"全部"
            let title = newValue ? "全部板块" : self.blockName
            self.navigationController?.title = title
            self.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragonCode = DataCache.marketDragon?.code
        self.showAllStocks = false
        self.prepareData()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UINib(nibName: "ZhangTingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "ZhangTingStockTableViewCell")
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.reloadData()
    }
    
    @IBAction func onRightBarButtonClicked(_ sender: UIBarButtonItem) {
        self.showAllStocks = !self.showAllStocks
        self.prepareData()
        self.reloadData()
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
        // 排序
        dataList.sort { (lhs, rhs) -> Bool in
            if (lhs.zhangting > rhs.zhangting) {
                return true
            } else if (lhs.zhangting < rhs.zhangting) {
                return false
            }
            let s1 = StockUtils.getStock(by: lhs.code)
            let s2 = StockUtils.getStock(by: rhs.code)
            return s1.tradeValue.floatValue <= s2.tradeValue.floatValue
        }
        self.dataList = dataList
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
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let s = self.dataList[indexPath.row]
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
}

extension BlockZhangTingListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = self.dataList[indexPath.row]
        StockUtils.gotoStockViewController(code: s.code, from: self.navigationController!)
    }
}

