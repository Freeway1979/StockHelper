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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.reloadData()
        
        self.webView.evaluateJavaScript("navigator.userAgent") { [unowned self] (data, error) in
//            print(data,error)
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            self.webView.customUserAgent = userAgent
        }
    }
    
    @IBAction func onMenuButtonClicked(_ sender: UIBarButtonItem) {
         toggleSideMenuView()
    }
    
//    http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    
    
    @IBAction func onBuildClicked(_ sender: UIButton) {
        prepareData()
    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
    }
    
    private func prepareData() {
        ZKProgressHUD.show()
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "所属概念 流通市值排序 前70", title: "个股和板块", status: "ddd")  { [unowned self] (date, json, dict) in
            print(json)
            self.buildPaginationService()
            self.goNext()
        }
        self.dataServices.append(dataService)
         WencaiUtils.loadWencaiQueryPage(webview: self.webView, dataService: self.dataServices.first!)
    }
    
    func buildPaginationService() {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "cacheToken", title: "分页数据", status: "ddd")  { [unowned self] (date, json, dict) in
            self.handleWenCaiResponse(date:date, dict: dict)
            self.goNext()
        }
        self.dataServices.append(dataService)
    }
    
    func goNext() {
        self.dataServices.removeFirst(1)
        if (self.dataServices.count == 0) {
            self.onDataLoaded()
        } else {
            if (self.dataServices.first!.keywords == "cacheToken") {
                let extra = "showType=[\"\",\"\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\"]"
                WencaiUtils.loadWencaiPaginationData(webview: self.webView, token: self.token!, perpage: 1, page: 1, extra: extra)
            } else {
                WencaiUtils.loadWencaiQueryPage(webview: self.webView, dataService: self.dataServices.first!)
            }
        }
    }
    
    private func onDataLoaded() {
//        self.convertToLayoutData()
        self.reloadData()
        ZKProgressHUD.dismiss()
    }
    
    func getDataService(by keywords:String) -> DataService? {
        return self.dataServices.first { (dataService) -> Bool in
            return dataService.keywords == keywords
        }
    }
    
    private func handleWenCaiResponse(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleWenCaiResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
//        var dict:[String:[ZhangTingStock]] = [:]
//        for item in rs {
//            let zt = (item[7] as! NSNumber).intValue
//            let zhangting = "\(zt)连板"
//            var list:[ZhangTingStock]? = dict[zhangting]
//            if (list == nil) {
//                list = []
//                dict[zhangting] = list
//            }
//            let code = item[0] as! String
//            let name = item[1] as! String
//            let gn:String? = item[9] as? String
//            var gnList:[String]? = []
//            if (gn != nil) {
//                gnList = gn?.components(separatedBy: ";")
//            }
//
//            let stock = ZhangTingStock(code: String(code.prefix(6)), name: name, zhangting: zt, gnList: gnList ?? [])
//            list?.append(stock)
//            dict[zhangting] = list
//        }
//        // Sort Dictionary
//        for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
//            let item = DataItem(zhangting: k, stocks: v)
//            self.dataList.append(item)
//        }
    }
    
}

extension DataBuildViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataServices[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        view.detailTextLabel?.text = item.status
        view.textLabel?.text = item.title
        return view
    }
    
    
}
extension DataBuildViewController:UITableViewDelegate {

    
}
extension DataBuildViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(navigation)
        
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
                    let keywords = dict["query"] as! String
                    let dataService = self.getDataService(by: keywords)
                    if ((dataService?.handler) != nil) {
                        dataService?.handler!(dataService!.date, jsonString,dict)
                    }
                })
            } else {
                print(rs)
                WencaiUtils.parseRawJSON(jsonString: rs, callback: { (dict) in
                    let dataService = self.getDataService(by: "cacheToken")
                    if ((dataService?.handler) != nil) {
                        dataService?.handler!(dataService!.date, rs,dict as! Dictionary<String, Any>)
                    }
                })
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
