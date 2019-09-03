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
        case STOCK = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = LoadData.loadData()
        if items.count == 0 {
            items.append(LoadData(title: "概念板块", status: false, count: 0, updateTime: nil))
            items.append(LoadData(title: "股票列表", status: false, count: 0, updateTime: nil))
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
        self.addService(dataService: dataService)
        if dataService.paginationService != nil {
         self.addService(dataService: dataService.paginationService!)
        }
        // Stock
        dataService = self.prepareStockData()
        self.addService(dataService: dataService)
        if dataService.paginationService != nil {
            self.addService(dataService: dataService.paginationService!)
        }
    }
    
    // 所有概念板块
    func prepareBlockData() -> DataService {
        let dataService = BlockDataService(date: Date().formatWencaiDateString(),keywords: "概念板块", title: "概念板块");
        dataService.onComplete = { [unowned self] (data) in
            guard let blocks = data else { return }
            let index = TABLE_ITEM.BLOCK.rawValue
            self.items[index].status = true
            self.items[index].count = blocks.count
            self.items[index].updateTime = Date()
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
        dataService.onComplete = { [unowned self] (data) in
            guard let stocks = data else { return }
            let index = TABLE_ITEM.STOCK.rawValue
            self.items[index].status = true
            self.items[index].count = stocks.count
            self.items[index].updateTime = Date()
            StockServiceProvider.stocks = stocks as! [Stock];
            StockServiceProvider.translateStocks2PinYin(stocks: stocks as! [Stock])
            StockDBProvider.saveBasicStocks(stocks: stocks as! [Stock])
            print("stocks", stocks.count)
            self.reloadData()
        }
        return dataService
    }
    
    override func onDataLoaded() {
        super.onDataLoaded()
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


