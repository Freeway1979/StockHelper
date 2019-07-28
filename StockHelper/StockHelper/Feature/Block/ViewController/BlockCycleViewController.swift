//
//  BlockCycleViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import ZKProgressHUD

class BlockCycleViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    var lastDate:String = ""
    var token:String?
    var dataServices: [DataService] = []
    var selectedItem: String? = "OLED"
    
    let LeftTableViewCellId = "leftTableViewCell"
    let RightTableViewCellId = "StackTableViewCell"
    let RightTableHeaderView = "StackTableHeaderView"
    
    var forceUpdate:Bool = false
    var top10List:[TopTen] = []
    var rightTopTenList:[OrderedBlockList] = []
    var runningDates:[String] = []
    var dates:[String] = []
    var headerDates:[String] = []
    
    class TopTen {
        var title: String = ""
        var score: Int = 0
        init(title:String, score: Int) {
            self.title = title
            self.score = score
        }
    }
    
    enum TableCellDimension:Int {
        case Width = 60
        case Height = 30
    }
    
    struct OrderedBlockList {
        var order:Int
        var blockList:[WenCaiBlockStat] = []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webview.navigationDelegate = self;
        WencaiUtils.prepareWebView(webview: webview);
        
        setupTableViews()
        
        prepareData()
        
    }
    
    private let blackList = ["富时罗素概念股","深股通","MSCI概念","沪股通","MSCI预期","参股新三板"];
    
    private var colors = [UIColor.white,UIColor.blue,UIColor.green,UIColor.gray,UIColor.brown,UIColor.yellow,UIColor.red]
    
    private func getColorByScore(score:Int) -> UIColor {
//        return colors[Int.randomIntNumber(lower: 0, upper: colors.count-1)]
        return UIColor.white
    }
    
    //左边的TopTen
    private func buildTopTen() -> [TopTen] {
        var blockScoreDic:[String:Int] = [:]
        DataCache.blockTops?.forEach({ (item) in
            let (_, value) = item
            value.forEach({ (block) in
                var vv = blockScoreDic[block.title]
                if (vv == nil) {
                    vv = 0
                }
                vv = vv! + block.score
                blockScoreDic[block.title] = vv
            })
        })
        
        var topList:[TopTen] = []
        var count = 0
        for (k,v) in (Array(blockScoreDic).sorted {$0.1 > $1.1}) {
            print("\(k):\(v)")
            let topTen = TopTen(title: k, score: v)
            topList.append(topTen)
            count = count + 1
            if (count >= 10) {
                break
            }
        }
        return topList
    }
    
    private func buildRightTopTenList() -> [OrderedBlockList] {
        var topList:[OrderedBlockList] = []
        //header
        var header = OrderedBlockList(order: 0, blockList: [])
        self.headerDates.forEach { (date) in
            var block:WenCaiBlockStat
            block = WenCaiBlockStat()
            block.title = date
            header.blockList.append(block)
        }
        topList.append(header)
        for i in 1...10 {
            var blockListObject = OrderedBlockList(order: i, blockList: [])
            self.dates.forEach { (date) in
                let blocks : [WenCaiBlockStat] = DataCache.getBlocksByDate(date: date)!
                var block: WenCaiBlockStat;
                if (blocks.count > i-1)
                {
                    block = blocks[i-1]
                } else {
                    block = WenCaiBlockStat()
                    block.title = ""
                }
                blockListObject.blockList.append(block)
            }
            topList.append(blockListObject)
        }
        return topList
    }
    
    private func handleGNBlocksWithMoney(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleGNBlocksWithMoney")
        let rs = dict["result"] as! [[Any]]
        let isLastDate = date == self.lastDate
        var count = 50
        var blocks:[WenCaiBlockStat]? = DataCache.getBlocksByDate(date: date) ?? nil
        blocks?.removeAll()
        // if is today ,update it
        // otherwise ignore
        for item in rs {
            let title = item[1] as! String
            if (count > 0) {
                let money = (item[5] as! NSNumber).intValue
                var zhangfu:Float;
                if isLastDate {
                    zhangfu = (item[3] as! NSNumber).floatValue
                } else {
                    zhangfu = (item[3] as! [NSNumber]).last!.floatValue
                }
                
                let block = WenCaiBlockStat()
                block.title = title
                block.money = money
                block.zhangting = 0
                block.zhangfu = zhangfu
                block.score = 0
                if (!WenCaiBlockStat.isBlackList(title: title))
                {
                    blocks?.append(block)
                }
            } else {
                break
            }
            count = count - 1
        }
        DataCache.setBlocksByDate(date: date, blocks: blocks ?? [])
    }
    
    private func handleGNBlocksWithZhangTingShu(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleGNBlocksWithZhangTingShu")
        let rs = dict["result"] as! [[Any]]
        var count = 50
        var blocks:[WenCaiBlockStat]? = DataCache.getBlocksByDate(date: date) ?? nil
        for item in rs {
            let title = item[1] as! String
            if (count > 0) {
                let zhangting = (item[4] as! NSNumber).intValue
                let block = blocks?.first(where: { (block) -> Bool in
                    return block.title == title
                })
                if (block != nil) {
                    block?.zhangting = zhangting
                }
            } else {
                break
            }
            count = count - 1
        }
        blocks?.forEach({ (block) in
            block.buildScore()
        })
        blocks?.sort(by: { (lhs: WenCaiBlockStat, rhs: WenCaiBlockStat) -> Bool in
            return lhs.score > rhs.score
        })
        count = 20 // Max Total 20
        blocks = blocks?.filter({ (block) -> Bool in
            let rs = count > 0 && block.zhangting > 0 && !WenCaiBlockStat.isBlackList(title: block.title)
            if (rs) {
                count = count - 1
            }
            return rs
        })
        DataCache.setBlocksByDate(date: date, blocks: blocks ?? [])
        self.goNext()
    }
    
    func goNext() {
        _ = self.runningDates.popLast()
        if (self.runningDates.count == 0) {
            self.onDataLoaded()
        } else {
            self.loadWenCaiData(date: self.runningDates.last!)
        }
    }

    func getDataService(by keywords:String) -> DataService? {
        return self.dataServices.first { (dataService) -> Bool in
            return dataService.keywords == keywords
        }
    }
    
    func loadDataPhase1(date:String) {
        let dataService = DataService(date: date, keywords: "\(date)概念板块资金 \(date)涨跌幅顺序 \(date)成交额大于100亿", title: "概念板块资金", status: "ddd")  { [unowned self] (date, json, dict) in
            self.handleGNBlocksWithMoney(date: date,dict: dict)
            self.loadDataPhase2(date: date)
        }
        self.dataServices.append(dataService)
        WencaiUtils.loadWencaiQueryPage(webview: webview, dataService: dataService)
    }
    
    func loadDataPhase2(date:String) {
        let dataService = DataService(date: date,keywords: "\(date)概念板块涨停数顺序 \(date)成交额大于100亿", title: "概念板块资金", status: "ddd")  { [unowned self] (date, json, dict) in

            self.handleGNBlocksWithZhangTingShu(date:date, dict: dict)
        }
        self.dataServices.append(dataService)
        WencaiUtils.loadWencaiQueryPage(webview: webview, dataService: dataService)
    }
    private let weekdays = ["周一","周二","周三","周四","周五","周六","周日"]
    private let ONE_DAY:TimeInterval = 3600*24;
    private func generateDates() -> [String] {
        var dates:[Date] = []
        let today = Date()
        var i = 0
        var count = 0
        while i < 30 {
            let date = Date(timeInterval: -ONE_DAY * Double(i), since: today)
            if (date.isWorkingDay) {
                count = count + 1
                dates.append(date)
                
            }
            if (count >= 10) {
                break
            }
            i = i + 1
        }
        
        let rs = dates.map { (date) -> String in
            let dateStr = date.formatWencaiDateString()
            let headerDateStr = "\(dateStr.suffix(5))\(self.weekdays[date.weekDay-1])"
            self.headerDates.append(headerDateStr)
            return dateStr
        }
        self.lastDate = rs.first!
        return rs
    }
    
    private func prepareData() {
        ZKProgressHUD.show()
        self.dates = self.generateDates()
        self.runningDates.append(contentsOf: self.dates)
        self.loadWenCaiData(date: self.runningDates.last!)
    }

    private func loadWenCaiData(date:String) {
        if !forceUpdate {
            let blocks:[WenCaiBlockStat]? = DataCache.getBlocksByDate(date: date) ?? nil
            if blocks?.count ?? 0 > 0 {
                print("\(date) already exists, go next")
                self.goNext()
                return
            }
        }
        self.loadDataPhase1(date: date);
    }
    
    private func setupTableData() {
        self.top10List = self.buildTopTen()
        self.rightTopTenList = self.buildRightTopTenList()
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
    }
    
    private func onDataLoaded() {
        DataCache.saveToDB()
        self.setupTableData()
        ZKProgressHUD.dismiss()
    }
    
    private func setupTableViews() {
        self.leftTableView.delegate = self
        self.leftTableView.dataSource = self
        self.rightTableView.delegate = self
        self.rightTableView.dataSource = self
        self.rightTableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        
        self.leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: LeftTableViewCellId)
        self.rightTableView.register(UINib(nibName: RightTableViewCellId, bundle: nil), forCellReuseIdentifier: RightTableViewCellId)
//        self.rightTableView.register(StackTableViewCell.classForCoder(), forCellReuseIdentifier: RightTableViewCellId)
    }

    private func isLeftTableView(tableView:UITableView) -> Bool {
        return self.leftTableView == tableView
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override func viewWillDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
}

extension BlockCycleViewController:UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let isLeft = isLeftTableView(tableView: tableView)
        if (isLeft) {
            return self.top10List.count
        }
      
        return self.rightTopTenList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLeft = isLeftTableView(tableView: tableView)
        let cellId = isLeft ? LeftTableViewCellId : RightTableViewCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // Configure the cell...
        var title = ""
        if isLeft {
            title = self.top10List[indexPath.row].title
            cell.textLabel!.text = title;
            cell.textLabel!.font = UIFont(name: "Arial", size: 12)
            cell.textLabel!.textAlignment = .center
        }
        else {
            let stackTableViewCell = cell as! StackTableViewCell
            let stackView = stackTableViewCell.stackView
            let hotblock = self.rightTopTenList[indexPath.row]
            let blockList = hotblock.blockList
            stackView?.spacing = 0
            stackView?.distribution = .fillEqually
            stackView?.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            for i in 0...blockList.count-1 {
                let button:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: TableCellDimension.Width.rawValue, height: TableCellDimension.Height.rawValue))
                let text = blockList[i].title
                var titleColor = UIColor.black
                var bgcolor = indexPath.row == 0 ? UIColor.lightGray: UIColor.white
                if (text == self.selectedItem) {
                    bgcolor = UIColor.red
                    titleColor = UIColor.white
                }
                button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                button.backgroundColor = bgcolor
                button.setTitleColor(titleColor, for: UIControl.State.normal)
                button.setTitle(text, for: UIControl.State.normal)
                button.layer.borderWidth = 0.3
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.cornerRadius = 0
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                stackView?.addArrangedSubview(button)
            }
        }

        return cell
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if (sender.titleLabel?.text != nil && sender.titleLabel?.text!.count ?? 0 > 0) {
        self.selectedItem = sender.titleLabel?.text!
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLeftTableView(tableView: tableView) {
            var view: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeftTableHeaderView")
            if view == nil {
                view = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: 120, height: TableCellDimension.Height.rawValue))
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLeftTableView(tableView: tableView) {
            return "Top 10"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLeftTableView(tableView: tableView) {
            return 30
        }
        return 0
    }
}
extension BlockCycleViewController:UITableViewDelegate {
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
        if isLeftTableView(tableView: tableView) {
           self.selectedItem = self.top10List[indexPath.row].title
        } else {
            
        }
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
}

extension BlockCycleViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { [unowned self] (data, error) in
            
            let rs = data as! String
            
            if (rs.contains("token")) {
//                print("token found")
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
            } else {
//                print("token not found")
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
