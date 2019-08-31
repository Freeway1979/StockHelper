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

class DataBuildViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
    var token:String?
    var dataServices: [DataService] = []
    var dataService: DataService?
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
        self.webView.navigationDelegate = self;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData()
        
        self.webView.evaluateJavaScript("navigator.userAgent") { [unowned self] (data, error) in
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            self.webView.customUserAgent = userAgent
        }
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
        prepareBlockData()
    }
    
//    http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    
    
    @IBAction func onBuildClicked(_ sender: UIButton) {
        ZKProgressHUD.show()
        prepareBlockData()
    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
    }
    
    func prepareBlockData() {
        let dataService = DataService(date: Date().formatWencaiDateString(),keywords: "概念板块", title: "概念板块", status: "ddd")  { [unowned self] (date, json, dict) in
            self.buildBlockPaginationService()
            self.goNext()
        }
        self.dataServices.append(dataService)
        self.dataService = dataService
        WencaiUtils.loadWencaiQueryPage(webview: self.webView, dataService: self.dataServices.first!)
    }
    
    private func prepareStockData() {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "所属概念 前5000", title: "个股和板块", status: "ddd")  { [unowned self] (date, json, dict) in
            self.buildStockPaginationService()
            self.goNext()
        }
        self.dataServices.append(dataService)
         WencaiUtils.loadWencaiQueryPage(webview: self.webView, dataService: self.dataServices.first!)
    }
    
    func buildStockPaginationService() {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "cacheToken", title: "StockList", status: "ddd")  { [unowned self] (date, json, dict) in
            let stocks = self.handleWenCaiStocksResponse(date:date, dict: dict)
            let index = TABLE_ITEM.STOCK.rawValue
            self.items[index].status = true
            self.items[index].count = stocks.count
            self.items[index].updateTime = Date()
            StockServiceProvider.stocks = stocks;
            StockServiceProvider.translateStocks2PinYin(stocks: stocks)
            StockDBProvider.saveBasicStocks(stocks: stocks)
            print("stocks", stocks.count)
            self.reloadData()
            self.goNext()
        }
        self.dataServices.append(dataService)
    }
    
    func buildBlockPaginationService() {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "cacheToken", title: "BlockList", status: "ddd")  { [unowned self] (date, json, dict) in
            let blocks:[Block] = self.handleWenCaiBlocksResponse(date:date, dict: dict)
            let index = TABLE_ITEM.BLOCK.rawValue
            self.items[index].status = true
            self.items[index].count = blocks.count
            self.items[index].updateTime = Date()
            StockServiceProvider.blocks = blocks;
            StockServiceProvider.translateBlocks2PinYin(blocks: blocks)
            StockDBProvider.saveBasicBlocks(blocks: blocks)
            self.reloadData()
            self.prepareStockData()
            self.goNext()
        }
        self.dataServices.append(dataService)
    }
    
    func goNext() {
        self.dataServices.removeFirst(1)
        if (self.dataServices.count == 0) {
            self.onDataLoaded()
        } else {
            self.dataService = self.dataServices.first
            if (self.dataServices.first!.keywords == "cacheToken") {
                let extra = "showType=[\"\",\"\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\"]"
                let perpage = self.dataService?.title == "BlockList" ? 1000 : 5000
                WencaiUtils.loadWencaiPaginationData(webview: self.webView, token: self.token!, perpage: perpage, page: 1, extra: extra)
            } else {
                WencaiUtils.loadWencaiQueryPage(webview: self.webView, dataService: self.dataServices.first!)
            }
        }
    }
    
    private func onDataLoaded() {
        StockServiceProvider.buildBlock2StocksCodeMap()
        self.reloadData()
        ZKProgressHUD.dismiss()
        LoadData.saveData(loadDataList: self.items)
    }
    
    func getDataService(by keywords:String) -> DataService? {
        return self.dataServices.first { (dataService) -> Bool in
            return dataService.keywords == keywords
        }
    }
    
    private func handleWenCaiStocksResponse(date:String,dict:Dictionary<String, Any>) -> [Stock] {
        print("\(date) handleWenCaiStocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var stocks:[Stock] = []
        for item in rs {
            let zt = 0
//            if (item[6] is NSNumber) {
//                zt = (item[6] as! NSNumber).intValue
//            }
            let code = item[0] as! String
            let name = item[1] as! String
            let tradeValue = item[6] as? String
            let gn:String? = item[4] as? String
            let stock = Stock(code: String(code.prefix(6)), name: name)
            stock.tradeValue = tradeValue ?? ""
            stock.zt = zt
            stock.gnListStr = gn ?? ""
            stocks.append(stock)
            print(stock.description)
        }
        return stocks
    }
    
    private func handleWenCaiBlocksResponse(date:String,dict:Dictionary<String, Any>) -> [Block] {
        print("\(date) handleWenCaiShandleWenCaiBlocksResponsetocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var blocks:[Block] = []
        for item in rs {
            let code = item[0] as! String
            let name = item[1] as! String
            let block = Block(code: String(code.prefix(6)), name: name)
            blocks.append(block)
            print(block.description)
        }
        return blocks
    }
    //
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

extension DataBuildViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        //   修改界面元素的值
//        let findInputScript = "document.getElementsByTagName('textarea')[0].value='二级行业板块';";
//        webView.evaluateJavaScript(findInputScript) { (data, error) in
//            let rs = data as! String
//            print(rs)
//            let findSearchSubmitScript = "document.getElementsByTagName('form')[0].submit();"
//            webView.evaluateJavaScript(findSearchSubmitScript) { (data, error) in
//                let rs = data as! String
//                print(rs)
//            }
//        }
        webView.evaluateJavaScript("document.body.innerHTML") { [unowned self] (data, error) in
            let rs = data as! String
            if (rs.contains("token")) {
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
                WencaiUtils.parseHTML(html: rs, callback: { [unowned self] (jsonString, dict) in
                    let dataService = self.dataService // self.getDataService(by: keywords)
                    if ((dataService?.handler) != nil) {
                        dataService?.handler!(dataService!.date, jsonString,dict)
                    }
                })
            } else {
                let (dict, json) = WencaiUtils.parseResultDataFromHTML(html: rs)
                if (dict != nil) {
                    let dataService = self.dataService
                    if ((dataService?.handler) != nil) {
                        dataService?.handler!(dataService!.date, json, dict! )
                    }
                }
            }
        }
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


