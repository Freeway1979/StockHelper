//
//  BlockCycleViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit

class BlockCycleViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    var token:String?
    var dataServices: [DataService] = []
    
    let LeftTableViewCellId = "leftTableViewCell"
    let RightTableViewCellId = "StackTableViewCell"
    let RightTableHeaderView = "StackTableHeaderView"
    
    var top10List:[TopTen] = []
    var latestHotBlockList:[LatestHotBlock] = []
    
    struct TopTen {
        var title = ""
        var code = ""
        var score = 0
    }
    
    enum TableCellDimension:Int {
        case Width = 60
        case Height = 30
    }
    
    struct LatestHotBlock {
        var date = ""
        var blockList:[TopTen] = []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webview.navigationDelegate = self;
        WencaiUtils.prepareWebView(webview: webview);
        
        setupTableViews()
        
        prepareData()
        
    }
    
    private var titles = ["猪肉","氢能源","鸡肉","中药","芬太尼","超级品牌","通信设备","互联网彩票","手机游戏"]
    private var colors = [UIColor.white,UIColor.blue,UIColor.green,UIColor.gray,UIColor.brown,UIColor.yellow,UIColor.red]
    private func getMockTopTen() -> TopTen {
        let title = titles[Int.randomIntNumber(lower: 0, upper: 9)]
        let score = Int.randomIntNumber(lower: 0, upper: 100)
        let code = "88990\(Int.randomIntNumber(lower: 0, upper: 9))"
        return TopTen(title: title, code: code, score: score)
    }
    
    private func getColorByScore(score:Int) -> UIColor {
       //return colors[score % colors.count]
        return colors[Int.randomIntNumber(lower: 0, upper: colors.count-1)]
    }
    
    private func getMockupTopTenList() -> [TopTen] {
        var topList:[TopTen] = []
        for _ in 0...9 {
            topList.append(getMockTopTen())
        }
        
        return topList
    }
    private func getMockupTopTenHeaderList() -> [TopTen] {
        var topList:[TopTen] = []
        for item in self.latestHotBlockList {
            let date = item.date
            topList.append(TopTen(title: date, code: date, score: 0))
        }
        return topList
    }
    
    private func handleGNBlocksWithMoney(dict:Dictionary<String, Any>) {
        let rs = dict["result"] as! [[Any]]
        let titles = dict["title"] as! [String]
        let s = titles[3]
        let date = String(s.suffix(10))
        
        var count = 30
        var blocks:[WenCaiBlockStat]? = DataCache.getBlocksByDate(date: date) ?? nil
        blocks?.removeAll()
        // if is today ,update it
        // otherwise ignore
        for item in rs {
            print(item)
            if (count > 0) {
                let money = (item[5] as! NSNumber).intValue
                let zhangfu = (item[3] as! NSNumber).floatValue
                let block = WenCaiBlockStat()
                block.title = item[1] as! String
                block.money = money
                block.zhangting = 0
                block.zhangfu = zhangfu
                block.score = 0
                print(block)
                blocks?.append(block)
            } else {
                break
            }
            count = count - 1
        }
        DataCache.setBlocksByDate(date: date, blocks: blocks ?? [])
        DataCache.printData()
    }
    
    private func handleGNBlocksWithZhangTingShu(dict:Dictionary<String, Any>) {
        let rs = dict["result"] as! [[Any]]
        let titles = dict["title"] as! [String]
        let s = titles[3]
        let date = String(s.suffix(10))
        
        var count = 30
        let blocks:[WenCaiBlockStat]? = DataCache.getBlocksByDate(date: date) ?? nil
        for item in rs {
            print(item)
            if (count > 0) {
                let zhangting = (item[4] as! NSNumber).intValue
                let title = item[1] as! String
                var block = blocks?.first(where: { (block) -> Bool in
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
        DataCache.setBlocksByDate(date: date, blocks: blocks ?? [])
        DataCache.printData()
    }
    
    func getDataService(by keywords:String) -> DataService? {
        return self.dataServices.first { (dataService) -> Bool in
            return dataService.keywords == keywords
        }
    }
    
    func loadDataPhase1() {
        let dataService = DataService(keywords: "概念板块资金 涨跌幅顺序 成交额大于100亿", title: "概念板块资金", status: "ddd")  { [unowned self] (json, dict) in
            self.handleGNBlocksWithMoney(dict: dict)
            self.loadDataPhase2()
        }
        self.dataServices.append(dataService)
        WencaiUtils.loadWencaiQueryPage(webview: webview, dataService: dataService)
    }
    
    func loadDataPhase2() {
        let dataService = DataService(keywords: "概念板块涨停数顺序 成交额大于100亿", title: "概念板块资金", status: "ddd")  { [unowned self] (json, dict) in
            self.handleGNBlocksWithZhangTingShu(dict: dict)
        }
        self.dataServices.append(dataService)
        WencaiUtils.loadWencaiQueryPage(webview: webview, dataService: dataService)
    }
    
    private func prepareData() {
        self.loadDataPhase1();
//        self.top10List.append(contentsOf: getMockupTopTenList())
//
//        for i in 0...9 {
//            let hotblock = LatestHotBlock(date: "04-0\(i+1)", blockList: getMockupTopTenList())
//            latestHotBlockList.append(hotblock)
//        }
//        latestHotBlockList.insert(LatestHotBlock(date: "", blockList: getMockupTopTenHeaderList()), at: 0)
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
      
        return self.latestHotBlockList.count
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
            let hotblock = self.latestHotBlockList[indexPath.row]
            let blockList = hotblock.blockList
            stackView?.spacing = 0
            stackView?.distribution = .fillEqually
            for i in 0...blockList.count-1 {
                let button:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: TableCellDimension.Width.rawValue, height: TableCellDimension.Height.rawValue))
                let text = blockList[i].title
                let color = indexPath.row==0 ? UIColor.white:getColorByScore(score: blockList[i].score)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                button.backgroundColor = color
                button.setTitleColor(UIColor.black, for: UIControl.State.normal)
                button.setTitle(text, for: UIControl.State.normal)
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.cornerRadius = 0
                stackView?.addArrangedSubview(button)
            }
        }

        return cell
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
                print("token found")
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
            } else {
                print("token not found")
            }
            
            WencaiUtils.parseHTML(html: rs, callback: { [unowned self] (jsonString, dict) in
                print(dict)
                let keywords = dict["query"] as! String
                let dataService = self.getDataService(by: keywords)
                if ((dataService?.handler) != nil) {
                    dataService?.handler!(jsonString,dict)
                }
            })
        }
    }
}
