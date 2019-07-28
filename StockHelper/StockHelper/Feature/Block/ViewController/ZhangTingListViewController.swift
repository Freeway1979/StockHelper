//
//  ZhangTingListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/7/28.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import ZKProgressHUD

class ZhangTingListViewController: UIViewController {
    
    let tableViewCellId = "StackTableViewCell"
    
    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataServices: [DataService] = []
    var dataService: DataService?
    var token:String?
    
    var zhenfuList:[ZhenFuStock] = []
    var dataList:[DataItem] = []
    
    struct DataItem {
        var zhangting:String
        var stocks:[ZhangTingStock]
    }
    
    struct ZhenFuStock {
        var code:String
        var name:String
        var zhangfu:String
        var zhenfu:String
    }
    
    struct ZhangTingStock {
        var code:String
        var name:String
        var zhangting:Int
        var gnList:[String]
    }
    
    enum TableCellDimension:Int {
        case Width = 60
        case Height = 30
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webview.navigationDelegate = self;
        self.title = "涨停排行榜"
        WencaiUtils.prepareWebView(webview: webview);
        
        setupTableViews()
        
        prepareData()
        
    }
    
    func getDataService(by keywords:String) -> DataService? {
        return self.dataServices.first { (dataService) -> Bool in
            return dataService.keywords == keywords
        }
    }
    
    func goNext() {
        self.dataServices.removeFirst(1)
        if (self.dataServices.count == 0) {
            self.onDataLoaded()
        } else {
            self.loadWenCaiData(dataService: self.dataServices.first!)
        }
    }
    
    func loadWenCaiData(dataService:DataService) {
        WencaiUtils.loadWencaiQueryPage(webview: webview, dataService: dataService)
    }
    
    private func handleWenCaiResponse(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleWenCaiResponse")
        let rs = dict["result"] as! [[Any]]
//        print(rs)
        var dict:[String:[ZhangTingStock]] = [:]
        for item in rs {
            let zt = (item[4] as! NSNumber).intValue
            let zhangting = "\(zt)连板"
            var list:[ZhangTingStock]? = dict[zhangting]
            if (list == nil) {
                list = []
                dict[zhangting] = list
            }
            let code = item[0] as! String
            let name = item[1] as! String
            let gn:String? = item[7] as? String
            var gnList:[String]? = []
            if (gn != nil) {
                gnList = gn?.components(separatedBy: ";")
            }
            let stock = ZhangTingStock(code: code, name: name, zhangting: zt, gnList: gnList ?? [])
            list?.append(stock)
            dict[zhangting] = list
        }
        // Sort Dictionary
        for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
            let item = DataItem(zhangting: k, stocks: v)
            self.dataList.append(item)
        }
    }
    
    private func handleWenCaiZhenFuResponse(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleWenCaiZhenFuResponse")
        let rs = dict["result"] as! [[Any]]
        var list:[ZhenFuStock] = []
        for item in rs {
            let zf = (item[4] as! String)
            let code = item[0] as! String
            let name = item[1] as! String
            let zhangfu = (item[7] as! String)
            let stock = ZhenFuStock(code: code, name: name, zhangfu: zhangfu, zhenfu: zf)
            list.append(stock)
        }
        self.zhenfuList = list
    }
    
    private func prepareData() {
        ZKProgressHUD.show()
        let today = Date().formatWencaiDateString()
        var dataService = DataService(date: today,keywords: "连续涨停数大于0且连续涨停天数排序且上市天数大于20天且非ST 所属概念", title: "连续涨停数排行榜", status: "ddd")  { [unowned self] (date, json, dict) in
            self.handleWenCaiResponse(date:date, dict: dict)
            self.goNext()
        }
        self.dataServices.append(dataService)
        
        dataService = DataService(date: today,keywords: "振幅大于15且非科创板且上市天数大于20", title: "连续涨停数排行榜", status: "ddd")  { [unowned self] (date, json, dict) in
            self.handleWenCaiZhenFuResponse(date:date, dict: dict)
            self.goNext()
        }
        self.dataServices.append(dataService)
        
        self.loadWenCaiData(dataService: self.dataServices.first!)
    }
    
    
    private func setupTableData() {
        self.tableView.reloadData()
    }
    
    private func onDataLoaded() {
        self.setupTableData()
        ZKProgressHUD.dismiss()
    }
    
    private func setupTableViews() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
//        self.tableView.register(UINib(nibName: tableViewCellId, bundle: nil), forCellReuseIdentifier: tableViewCellId)
         self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellId)
    }
    
}

extension ZhangTingListViewController:UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func createButton(text:String) -> UIButton {
        let button:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: TableCellDimension.Width.rawValue, height: TableCellDimension.Height.rawValue))
        let titleColor = UIColor.black
        let bgcolor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.backgroundColor = bgcolor
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 0
        return button
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId =  tableViewCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // Configure the cell...
        
//        let stackTableViewCell = cell as! StackTableViewCell
//        let stackView = stackTableViewCell.stackView
//
        let dataItem = self.dataList[indexPath.row]
        var text = dataItem.zhangting
        let ztbutton:UIButton = self.createButton(text: text)
        cell.addSubview(ztbutton)
        let bounds = cell.bounds
        let stackView = UIStackView(frame: CGRect(x: TableCellDimension.Width.rawValue, y: 0, width: Int(bounds.width - CGFloat(TableCellDimension.Width.rawValue)), height: TableCellDimension.Height.rawValue))
        
        let stocks = dataItem.stocks
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        
        for i in 0...stocks.count-1 {
            text = stocks[i].name
            let button = self.createButton(text: text)
            stackView.addArrangedSubview(button)
        }
        cell.addSubview(stackView)
        return cell
    }
    
    @objc func buttonTapped(sender: UIButton) {
//        if (sender.titleLabel?.text != nil && sender.titleLabel?.text!.count ?? 0 > 0) {
//            self.tableView.reloadData()
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension ZhangTingListViewController: UITableViewDelegate {
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            // Delete the row from the data source
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        } else if editingStyle == .insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //        }
    }
    
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
}

extension ZhangTingListViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { [unowned self] (data, error) in
            
            let rs = data as! String
            
            if (rs.contains("token")) {
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
            } else {
            }
            
            WencaiUtils.parseHTML(html: rs, callback: { [unowned self] (jsonString, dict) in
                let keywords = dict["query"] as! String
                let dataService = self.getDataService(by: keywords)
                if ((dataService?.handler) != nil) {
                    dataService?.handler!(dataService!.date, jsonString,dict)
                }
            })
        }
    }
}
