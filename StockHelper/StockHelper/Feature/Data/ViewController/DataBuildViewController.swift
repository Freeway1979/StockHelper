//
//  DataBuildViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/3/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import ZKProgressHUD
import SwiftSoup

class DataBuildViewController: DataServiceViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
    var items:[LoadData] = []
    
    enum TABLE_ITEM : Int {
        case BLOCK = 0
        case STOCK
        case YINGLI_STOCK
        case NIUKUI_STOCK
        case ZHANGTINGSHU_STOCK
        case JIEJIN_STOCK
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = LoadData.loadData()
//        items.removeAll()
        if items.count == 0 {
            items.append(LoadData(title: "概念板块", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "股票列表", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "盈利超2000万", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "扭亏为盈", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "120日内的涨停数", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "将要解禁", status: false, count: 0, updateTime: nil))
        }
        self.items = items
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData()
        self.setupWebView(webView: self.webView)
    }
    
    @IBAction func onMenuButtonClicked(_ sender: UIBarButtonItem) {
         toggleSideMenuView()
    }
   
    @IBAction func onRefreshButtonClicked(_ sender: UIBarButtonItem) {
        ZKProgressHUD.show()
        self.items.forEach { (item) in
            item.count = 0
            item.status = false
            item.updateTime = nil
        }
        self.reloadData()
        StockServiceProvider.resetData()
        prepareDataServices()
        self.runService(webView: self.webView, dataService: self.getFirstService()!)
    }
    
    @IBAction func onBuildClicked(_ sender: UIButton) {
        ZKProgressHUD.show()
        prepareDataServices()
        self.runService(webView: self.webView, dataService: self.getFirstService()!)
    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
    }

    func prepareDataServices() {
        self.removeServices()
        // Block
        var dataService = self.prepareBlockData()
        self.addServiceWithPagination(dataService: dataService)

        // Stock
        dataService = self.prepareStockData()
        self.addServiceWithPagination(dataService: dataService)
        // 盈利
        dataService = self.prepareYingLiStockData()
        self.addServiceWithPagination(dataService: dataService)
        // 扭亏
        dataService = self.prepareNiuKuiStockData()
        self.addServiceWithPagination(dataService: dataService)
        dataService = self.prepareZhangTingShuStockData()
        self.addServiceWithPagination(dataService: dataService)
        
        dataService = self.prepareJieJinStockData()
        self.addServiceWithPagination(dataService: dataService)
        
    }
    
    // 所有概念板块
    func prepareBlockData() -> DataService {
        let dataService = BlockDataService(date: Date().formatWencaiDateString(),keywords: "概念板块", title: "概念板块");
        dataService.onStart = { [unowned self] () in
            self.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let blocks = data else { return }
            self.finishItem(index: TABLE_ITEM.BLOCK.rawValue, count: blocks.count)
            StockServiceProvider.blocks = blocks as! [Block];
            StockServiceProvider.translateBlocks2PinYin(blocks: blocks as! [Block])
            StockDBProvider.saveBasicBlocks(blocks: blocks as! [Block])
            self.reloadData()
        }
        return dataService
    }
    

    // 所有股票
    private func prepareStockData() -> DataService {
        let today = Date().formatWencaiDateString()
        let dataService = StockDataService(date: today, keywords: "所属概念 前5000", title: "个股和板块")
        dataService.onStart = { [unowned self] () in
            self.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            self.finishItem(index: TABLE_ITEM.STOCK.rawValue, count: stocks.count)
            StockServiceProvider.stocks = stocks as! [Stock];
            StockServiceProvider.translateStocks2PinYin(stocks: stocks as! [Stock])
            StockDBProvider.saveBasicStocks(stocks: stocks as! [Stock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }
    
    //盈利>2000万股票
    private func prepareYingLiStockData() -> DataService {
        let dataService = YingLiStockDataService()
        dataService.onStart = { [unowned self] () in
            self.navigationController?.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            self.finishItem(index: TABLE_ITEM.YINGLI_STOCK.rawValue, count: stocks.count)
            StockDBProvider.saveYingLiStocks(stocks: stocks as! [YingLiStock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }
    
    //扭亏为盈股票
    private func prepareNiuKuiStockData() -> DataService {
        let dataService = NiuKuiStockDataService()
        dataService.onStart = { [unowned self] () in
            self.navigationController?.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            self.finishItem(index: TABLE_ITEM.NIUKUI_STOCK.rawValue, count: stocks.count)
            StockDBProvider.saveNiuKuiStocks(stocks: stocks as! [NiuKuiStock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }
    
    //120日涨停数股票
    private func prepareZhangTingShuStockData() -> DataService {
        let dataService = ZhangTingShuDataService()
        dataService.onStart = { [unowned self] () in
            self.navigationController?.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            self.finishItem(index: TABLE_ITEM.ZHANGTINGSHU_STOCK.rawValue, count: stocks.count)
            StockDBProvider.saveZhangTingShuStocks(stocks: stocks as! [ZhangTingShuStock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }

    //将要解禁
    private func prepareJieJinStockData() -> DataService {
        let dataService = JieJinStockDataService()
        dataService.onStart = { [unowned self] () in
            self.navigationController?.title = "数据 - \(dataService.title)"
        }
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            self.finishItem(index: TABLE_ITEM.JIEJIN_STOCK.rawValue, count: stocks.count)
            StockDBProvider.saveJieJinStockStocks(stocks: stocks as! [JieJinStock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }
    
    
    private func finishItem(index:Int, count:Int) {
        self.items[index].status = true
        self.items[index].count = count
        self.items[index].updateTime = Date()
    }
    
    override func onDataLoaded() {
        super.onDataLoaded()
        self.title = "数据"
        self.navigationController?.title = "数据"
        StockServiceProvider.buildBlock2StocksCodeMap()
        self.reloadData()
        ZKProgressHUD.dismiss()
        LoadData.saveData(loadDataList: self.items)
    }
}

extension DataBuildViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        view.accessoryType = item.status ? .checkmark : .none
        view.textLabel?.text = "\(item.title) \(item.count)"
        let updateTime = (item.updateTime != nil) ? item.updateTime!.format("yyyy-MM-dd HH:mm:ss") : ""
        view.detailTextLabel?.text = "最后更新时间:\(updateTime)"
        return view
    }
}

extension DataBuildViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.items[indexPath.row])
    }
}

extension DataBuildViewController: ENSideMenuDelegate {
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
}


