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
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID:String = "ZhangTingStockTableViewCell"
    public var dates:[String] = []
    public var blockName:String = ""
    var dataList:[ZhangTingStock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.blockName
        self.prepareData()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UINib(nibName: "ZhangTingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "ZhangTingStockTableViewCell")
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.reloadData()
    }
    func prepareData() {
        var dataList:[ZhangTingStock] = []
        self.dates.forEach { (date) in
            let zts:ZhangTingStocks? = DataCache.getZhangTingStocks(by: date)
            let list = zts?.stocks.filter({ (stock) -> Bool in
                stock.gnList.contains(self.blockName)
            }) ?? []
            dataList.append(contentsOf: list)
        }
        // 去重
        let set = Set(arrayLiteral: dataList)
        self.dataList = set.flatMap({ $0 })
        // 排序
        self.dataList.sort { (lhs, rhs) -> Bool in
            if (lhs.zhangting > rhs.zhangting) {
                return true
            } else if (lhs.zhangting < rhs.zhangting) {
                return false
            }
            let s1 = StockUtils.getStock(by: lhs.code)
            let s2 = StockUtils.getStock(by: rhs.code)
            return s1.tradeValue.floatValue <= s2.tradeValue.floatValue
        }
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
        let view:ZhangTingStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ZhangTingStockTableViewCell
        let s = self.dataList[indexPath.row]
        let stock = StockUtils.getStock(by: s.code)
        let dragons = 1
        let title:String = "连板:\(s.zhangting) 叠加龙头概念:\(dragons)"
        var line1:String = "\(s.code) 流通值:\(stock.tradeValue.formatMoney)"
        let yingli = stock.yingliStr
        if yingli != nil {
            line1 = "\(line1) 盈利:\(yingli!)"
        }
        let jiejin = stock.jiejinStr
        if jiejin != nil {
            line1 = "\(line1) 解禁:\(jiejin!)"
        }
        let line2:String = "封单额\(s.ztMoney.formatMoney) 封成比:\(s.ztRatioBills.formatDot2FloatString) 封流比:\(s.ztRatioMoney.formatDot2FloatString)"
        let badge = s.ztBanType
        view.applyModel(name: s.name, title: title, line1: line1, line2: line2, badge: badge)
        return view
    }
}

extension BlockZhangTingListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = self.dataList[indexPath.row]
        StockUtils.gotoStockViewController(code: s.code, from: self.navigationController!)
    }
}

