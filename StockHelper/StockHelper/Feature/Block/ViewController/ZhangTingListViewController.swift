//
//  ZhangTingListViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/8/11.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

//
//  HomeViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import ZKProgressHUD

private let reuseIdentifier = "Cell"

fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let columns = 5
fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)


class ZhangTingListViewController: DataServiceViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var webview: WKWebView!
    
    private struct ItemData {
        var title: String = ""
        var data: String? = ""
        var onItemClicked : (_ item:ItemData) -> Void
    }
    
    private class LayoutData {
        var title:String = ""
        var data: [ItemData] = []
        init(title:String,data:[ItemData]) {
            self.title = title
            self.data = data
        }
    }
    
    private var layoutData:[LayoutData] = []
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)
        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        let theWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.view.addSubview(theWebView)
        self.webview = theWebView
        self.webview.navigationDelegate = self;
        WencaiUtils.prepareWebView(webview: webview);
        
        self.setupLayoutData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.delegate = self;
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
        var item:ItemData?
        var title:String
        var layout:LayoutData?
        var items:[ItemData] = []
        // Item 4
        item = ItemData(title: "最高板损益值", data: "http://data.10jqka.com.cn/market/xsjj/", onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        layout = LayoutData(title: "涨停情绪",data: items)
        self.layoutData.append(layout!)
    }
    
    private func openWebSite(itemData:ItemData) {
        WebViewController.open(website: (itemData.data!), withtitle: itemData.title, from: (self.navigationController?.navigationController)!)
    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.collectionView.reloadData()
        })
        
    }
    
    func loadData() -> Void {
        prepareData()
        ZKProgressHUD.show()
        self.runService(webView: self.webview, dataService: self.getFirstService()!)
    }
    
    private func handleWenCaiResponse(date:String,dict:Dictionary<String, Any>) {
        print("\(date) handleWenCaiResponse")
        let rs = dict["result"] as! [[Any]]
        //        print(rs)
        var dict:[String:[ZhangTingStock]] = [:]
        for item in rs {
            let zt = (item[7] as! NSNumber).intValue
            let zhangting = "\(zt)连板"
            var list:[ZhangTingStock]? = dict[zhangting]
            if (list == nil) {
                list = []
                dict[zhangting] = list
            }
            let code = item[0] as! String
            let name = item[1] as! String
            let gn:String? = item[9] as? String
            var gnList:[String]? = []
            if (gn != nil) {
                gnList = gn?.components(separatedBy: ";")
            }
          
            let stock = ZhangTingStock(code: String(code.prefix(6)), name: name, zhangting: zt, gnList: gnList ?? [])
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
        print(list)
    }
    
    private func prepareData() {
        let today = Date().formatWencaiDateString()
        var dataService = DataService(date: today,keywords: "连续涨停数大于0且连续涨停天数排序且上市天数大于20天且非ST 所属概念 前500", title: "连续涨停数排行榜")
        dataService.handler = { [unowned self] (date, json, dict) in
            print(json)
            self.handleWenCaiResponse(date:date, dict: dict)
        }
        self.addService(dataService: dataService)

        dataService = DataService(date: today,keywords: "振幅大于15且非科创板且上市天数大于20 开盘涨跌幅", title: "连续涨停数排行榜")
        dataService.handler = { [unowned self] (date, json, dict) in
            self.handleWenCaiZhenFuResponse(date:date, dict: dict)
        }
        self.addService(dataService: dataService)
    }
    
    private func convertToLayoutData() {
        self.dataList.forEach { (item) in
            let items:[ItemData] = item.stocks.map({ (stock) -> ItemData in
                let itemData = ItemData(title: stock.name, data: stock.code, onItemClicked: { [unowned self] (itemData) in
                    print(itemData)
                    self.showLiandongActionSheet(item: itemData)
                })
                return itemData
            })
            let layout = LayoutData(title: item.zhangting,data: items)
            self.layoutData.append(layout)
        }
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
                StockUtils.openStockHQPage(code: item.data!, name: item.title, from: self.navigationController!)
            })
            alertController.addAction(hangqingAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource
extension ZhangTingListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.layoutData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.layoutData[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let group = self.layoutData[section]
        
        let item = group.data[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
            as! TagCollectionViewCell
        cell.contentButton.text = item.title
        cell.contentButton.setTextStyle(textStyle: TagButton.TextStyle.medium)
        
        cell.onClicked = { () -> Void in
            print("Button clicked:\(cell.contentButton.text!)")
            item.onItemClicked(item)
        }
        // Configure the cell
        
        return cell
    
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let group = self.layoutData[indexPath.section]
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerReuseIdentifier,
                                                                             for: indexPath) as! HeaderCollectionView
            let title = indexPath.section == 0 ? group.title : "\(group.title)(\(group.data.count))"
            headerView.contentLabel.text = title
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension ZhangTingListViewController: UICollectionViewDelegate {
    
    //      Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //      Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = self.layoutData[section].data[row]
        print(item)
    }
    
    //      Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
}

extension ZhangTingListViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let screenWidth = UIScreen.main.bounds.size.width;
        let height = Theme.CellView.height
        let width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
//        if width < Int(Theme.TagButton.width) {
//            width = Int(Theme.TagButton.width)
//        }
        //        if indexPath.section == SectionType.HotStocks.rawValue {
        //            return CGSize(width: screenWidth, height: 60)
        //        }
        return CGSize(width: width, height: Int(height))
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        //        if section == SectionType.HotStocks.rawValue {
        //            return stockSectionInsets
        //        }
        return sectionInsets
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // 5
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: CGFloat(Theme.CollectionHeaderView.height))
    }
}


