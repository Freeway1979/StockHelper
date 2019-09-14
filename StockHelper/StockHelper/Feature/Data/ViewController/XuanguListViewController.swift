//
//  XuanguListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//


import UIKit
import WebKit
import ZKProgressHUD

class XuanguListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var inTopBlocks:Bool = false
    var inZiXuanGu:Bool = false
  
    var checkItems:[CheckItem] = []
    var items:[DataItem] = []
    
    enum CheckItemType:Int {
        case ZIXUANGU = 0
        case TOPBLOCKS
    }

    struct DataItem {
        var title = ""
        var detail = ""
    }
    
    class CheckItem {
        var title = ""
        var checked:Bool = false
        required init(title:String, checked:Bool) {
            self.checked = checked
            self.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareData()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.reloadData()
    }
    func prepareData() {
        self.checkItems.append(CheckItem(title: "自选股", checked: false))
        self.checkItems.append(CheckItem(title: "热门板块", checked: false))
        //以后配置在远程服务器
        self.items.append(DataItem(title: "周线趋势股", detail: "3周内的最高价为60周内最高价且3周内的最高价大于60周内的最低价的2倍且3周内的最高价小于60周内的最低价的3倍且流通市值小于300亿"))
        self.items.append(DataItem(title: "超短8日3倍涨停过", detail: "(8日内的最高成交量)/(2日内的最低成交量)大于3且60日内的涨停数大于0且非科创板且非ST且盈利超过3000万且流通市值小于200亿"))
        self.items.append(DataItem(title: "超短5日2倍涨停过", detail: "(5日内的最高成交量)/今日成交量大于2且5日内的涨停数大于0且非科创板且非ST且盈利超过3000万"))
        self.items.append(DataItem(title: "超短3日2倍尾盘", detail: "前3日涨停 前2日放量 今日换手率为3日内的最小值 非科创板 非ST"))
        self.items.append(DataItem(title: "超短2日2倍涨停过", detail: "前2日涨停 昨日放量 今日换手率小于昨日换手率的二分之一 非科创板 非ST"))
        self.items.append(DataItem(title: "长上影线", detail: "昨日长上影线且流通市值小于200亿且非科创板非ST且盈利超过3000万"))
    }
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.tableView.reloadData()
        })
    }
    func copyQuery(query:String) {
        let board = UIPasteboard.general
        var text = query
        if self.checkItems[CheckItemType.ZIXUANGU.rawValue].checked {
            text = "\(text)且自选股"
        }
        if self.checkItems[CheckItemType.TOPBLOCKS.rawValue].checked {
            let blocks = Array(DataCache.getTopBlockNames().prefix(10))
            let blockNames = "(\(blocks.joined(separator: "或")))"
            text = "\(text)且\(blockNames)"
        }
        if text.count > 0 {
            board.string = text
            ZKProgressHUD.showMessage("问句已复制到剪切板")
        }
    }
}

extension XuanguListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.checkItems.count
        }
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            let item = self.checkItems[indexPath.row]
            view.accessoryType = item.checked ? .checkmark : .none
            view.textLabel?.text = item.title
        } else {
            let item = self.items[indexPath.row]
            view.textLabel?.text = item.title
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "叠加选项"
        }
        
        return "自定义选股"
        
    }
}

extension XuanguListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = self.checkItems[indexPath.row]
            item.checked = !item.checked
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: UITableView.RowAnimation.automatic)
            self.copyQuery(query: "")
        } else {
            let item = self.items[indexPath.row]
            self.copyQuery(query: item.detail)
        }
    }
}

