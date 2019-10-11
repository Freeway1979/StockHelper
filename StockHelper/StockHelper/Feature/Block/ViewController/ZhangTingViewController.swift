//
//  ZhangTingViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/7.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import ZKProgressHUD

class ZhangTingViewController: DataServiceViewController {
    
    let cellID:String = "ZhangTingStockTableViewCell"
    
    var webview: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
   private struct ItemData {
        var title: String = ""
        var data: String? = ""
        var sameblocks:[String] = []
        var onItemClicked : (_ item:ItemData) -> Void
    }
    
    private class LayoutData {
        var title:String = ""
        var data: [ZhangTingStock] = []
        init(title:String,data:[ZhangTingStock]) {
            self.title = title
            self.data = data
        }
    }
    
    private var layoutData:[LayoutData] = []
    
    var zhenfuList:[ZhenFuStock] = []
    struct ZhenFuStock {
        var code:String
        var name:String
        var openZhangfu:String
        var closeZhangfu:String
        var zhenfu:String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //WebView
        let theWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.view.addSubview(theWebView)
        self.webview = theWebView
        self.webview.navigationDelegate = self;
        WencaiUtils.prepareWebView(webview: webview);
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(UINib(nibName: "ZhangTingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "ZhangTingStockTableViewCell")
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.reloadData()
        
        self.setupLayoutData()
        // Do any additional setup after loading the view.
        loadData()
    }

    
    private func gotoViewController(storyboard:String,storyboardId:String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard,bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        self.navigationController?.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    private func setupLayoutData() {

    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
        
    }
    
    func loadData() -> Void {
        prepareData()
        ZKProgressHUD.show()
        self.runService(webView: self.webview, dataService: self.getFirstService()!)
    }
    
    private func handleWenCaiZhenFuResponse(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleWenCaiZhenFuResponse")
        let rs = dict["result"] as! [[Any]]
        var list:[ZhenFuStock] = []
        for item in rs {
            let zf = (item[4] as! String)
            let code = item[0] as! String
            let name = item[1] as! String
            let openZhangfu = (item[7] as! String)
            let closeZhangfu = (item[8] as! String)
            let stock = ZhenFuStock(code: String(code.prefix(6)), name: name,
                                    openZhangfu: openZhangfu, closeZhangfu: closeZhangfu,zhenfu: zf)
            list.append(stock)
        }
        list.sort { (lhs, rhs) -> Bool in
            return lhs.zhenfu.floatValue > rhs.zhenfu.floatValue
        }
        self.zhenfuList = list
        print(list)
    }
    
    private func prepareData() {
        let today = Date().formatWencaiDateString()
        var dataService:DataService = ZhangTingDataService(date: today)
        dataService.onComplete = { (data) in
            guard var stocks:[ZhangTingStock] = data as? [ZhangTingStock] else { return }
            let ztstocksWithDate = ZhangTingStocks(date: today, stocks: [])
            stocks.sort { (lhs, rhs) -> Bool in
               return lhs.zhangting > rhs.zhangting
            }
            DataCache.ztStocks.removeAll { (s) -> Bool in
                return s.date == today
            }
            ztstocksWithDate.stocks.removeAll()
            ztstocksWithDate.stocks = stocks
            DataCache.ztStocks.append(ztstocksWithDate)
            
//            //转换
//            var dict:[String:[ZhangTingStockItem]] = [:]
//            for item in stocks {
//                let zhangting = "\(item.zhangting)连板"
//                var list:[ZhangTingStockItem]? = dict[zhangting]
//                if (list == nil) {
//                    list = []
//
//                }
//                let stock = ZhangTingStockItem(code: item.code, name: item.name, zhangting: item.zhangting, gnList: item.gnList)
//                list?.append(stock)
//                dict[zhangting] = list
//            }
//            // Sort Dictionary
//            for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
//                let item = DataItem(zhangting: k, stocks: v)
//                self.dataList.append(item)
//            }
        }
        self.addService(dataService: dataService)

        dataService = DataService(date: today,keywords: "振幅大于15且非科创板且上市天数大于20 开盘涨跌幅", title: "连续涨停数排行榜")
        dataService.handler = { [unowned self] (date, json, dict) in
            self.handleWenCaiZhenFuResponse(date:date, dict: dict)
        }
        self.addService(dataService: dataService)
    }
    
    private func convertToLayoutData() {
        let today = Date().formatWencaiDateString()
        var dataList:[ZhangTingStock] = []
        let zts:ZhangTingStocks? = DataCache.getZhangTingStocks(by: today)
        dataList.append(contentsOf: zts?.stocks ?? [])
        
        var dicZT:[String:[ZhangTingStock]] = [:]
        zts?.stocks.forEach({ (stock) in
            let key = "\(stock.zhangting)"
            var stocks:[ZhangTingStock]? = dicZT[key]
            if stocks == nil {
                stocks = []
            }
            stocks?.append(stock)
            dicZT[key] = stocks!
        })
        var layoutData:[LayoutData] = []
        // Sort Dictionary
        for (k,v) in (Array(dicZT).sorted {$0.key > $1.key}) {
            let layout:LayoutData = LayoutData(title: "\(k)连板", data: v)
            layoutData.append(layout)
        }
        layoutData.forEach { (data) in
            data.data.sort { (lhs, rhs) -> Bool in
                let lhstock = StockUtils.getStock(by: lhs.code)
                let rhstock = StockUtils.getStock(by: rhs.code)
                //市值越小越靠前
                return lhstock.tradeValue.floatValue < rhstock.tradeValue.floatValue
            }
        }
        self.layoutData.removeAll()
        self.layoutData = layoutData
        
//        // 去重
//        let set = Set(arrayLiteral: dataList)
//        self.dataList = set.flatMap({ $0 })
//        // 排序
//        self.dataList.sort { (lhs, rhs) -> Bool in
//            if (lhs.zhangting > rhs.zhangting) {
//                return true
//            } else if (lhs.zhangting < rhs.zhangting) {
//                return false
//            }
//            let s1 = StockUtils.getStock(by: lhs.code)
//            let s2 = StockUtils.getStock(by: rhs.code)
//            return s1.tradeValue.floatValue <= s2.tradeValue.floatValue
//        }
//        // 振幅清单
//        let items:[ItemData] = self.zhenfuList.map { (zf) -> ItemData in
//            let suffix:String = zf.closeZhangfu.floatValue > 0 ? "↑" : "↓"
//            let itemData = ItemData(title: "\(zf.name)\(suffix)", data: zf.code, sameblocks: [],
//                                    onItemClicked: { [unowned self] (itemData) in
//                                    StockUtils.openStockHQPage(code: zf.code, name: zf.name, from: self.navigationController!)
//            })
//            return itemData
//        }
//        let layout = LayoutData(title: "振幅榜单",data: items)
//        self.layoutData.append(layout)
//
//        // 涨停清单
//        let dragonCode = self.dataList.first?.stocks.first?.code
//        if dragonCode != nil {
//            self.dataList.forEach { (item) in
//                let items:[ItemData] = item.stocks.map({ (stock) -> ItemData in
//                    var sameblocks:[String] = []
//                    if stock.code != dragonCode {
//                       sameblocks = StockUtils.getSameBlockNames(this: stock.code, that: dragonCode!)
//                    }
//                    let itemData = ItemData(title: stock.name, data: stock.code, sameblocks: sameblocks,
//                                            onItemClicked: { [unowned self] (itemData) in
//                                                print(itemData)
//                                                self.showLiandongActionSheet(item: itemData)
//                    })
//                    return itemData
//                })
//                let layout = LayoutData(title: item.zhangting,data: items)
//                self.layoutData.append(layout)
//            }
//        }
    }
    
    override func onDataLoaded() {
        self.convertToLayoutData()
        self.reloadData()
        ZKProgressHUD.dismiss()
    }
    
    private func gotoHotBlockViewController(item: ItemData) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Block",bundle: nil)
        var destViewController : HotBlockViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HotBlockViewController") as! HotBlockViewController
        destViewController.liandongStockCode = item.data
        destViewController.liandongStockName = item.title
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    private func showLiandongActionSheet(item:ItemData) {
        DispatchQueue.main.async { // 主线程执行
            let alertController = UIAlertController(title: item.title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:{ (action) -> Void in
                print("cancelled")
            })
            alertController.addAction(cancelAction)
            let liandongAction = UIAlertAction(title:"股票联动", style: .default, handler:{ [unowned self] (action) -> Void in
                print("联动\(String(describing: item.data))")
                self.gotoHotBlockViewController(item: item)
            })
            alertController.addAction(liandongAction)
            let hangqingAction = UIAlertAction(title:"股票行情", style: .default, handler:{ [unowned self] (action) -> Void in
                print("行情\(String(describing: item.data))")
                StockUtils.gotoStockViewController(code: item.data!, from: self.navigationController!)
            })
            alertController.addAction(hangqingAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ZhangTingViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.layoutData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layoutData[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view:ZhangTingStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ZhangTingStockTableViewCell
        let s = self.layoutData[indexPath.section].data[indexPath.row]
        let stock = StockUtils.getStock(by: s.code)
        let dragons = 1 //TODO:
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

extension ZhangTingViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:ZhangTingStock = self.layoutData[indexPath.section].data[indexPath.row]
        StockUtils.gotoStockViewController(code: item.code, from: self.navigationController!)
    }
}
