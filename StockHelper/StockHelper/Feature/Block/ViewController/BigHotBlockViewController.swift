//
//  BigHotBlockViewController.swift
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


class BigHotBlockViewController: DataServiceViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var webview: WKWebView!
    
    enum StockCategory:String {
        case LowestPrice = "最低价" //大妈热爱
        case LowestMarketValue = "最低流通市值" // 柚子热爱
        case MostLargeMarketValue = "最大流通市值" //中军 大资金热爱
        case LowestDealValue = "最小成交量" //最小换手率 表示惜筹严重，一致看好
        case MostLargeZhangTingOrder = "封成比排行" //封单坚决，一致看好 最正宗
        case MostLargeZhangTingShu = "涨停数排行" // 空间龙， 身位龙
    }
    
    private struct ItemData {
        var title: String = ""
        var data: String? = ""
        var sameblocks:[String] = []
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
    
    var dataList:[DataItem] = []
    
    struct DataItem {
        var zhangting:String
        var stocks:[ZhangTingStockItem]
    }
    
    struct ZhangTingStockItem {
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
        var dict:[String:[ZhangTingStockItem]] = [:]
        for item in rs {
            let zt = (item[7] as! NSNumber).intValue
            let zhangting = "\(zt)连板"
            var list:[ZhangTingStockItem]? = dict[zhangting]
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
          
            let stock = ZhangTingStockItem(code: String(code.prefix(6)), name: name, zhangting: zt, gnList: gnList ?? [])
            list?.append(stock)
            dict[zhangting] = list
        }
        // Sort Dictionary
        for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
            let item = DataItem(zhangting: k, stocks: v)
            self.dataList.append(item)
        }
    }
    
    
    private func prepareData() {
        let today = Date().formatWencaiDateString()
        let dataService:DataService = ZhangTingDataService(date: today)
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
            
            //转换
            var dict:[String:[ZhangTingStockItem]] = [:]
            for item in stocks {
                let zhangting = "\(item.zhangting)连板"
                var list:[ZhangTingStockItem]? = dict[zhangting]
                if (list == nil) {
                    list = []
                    
                }
                let stock = ZhangTingStockItem(code: item.code, name: item.name, zhangting: item.zhangting, gnList: item.gnList)
                list?.append(stock)
                dict[zhangting] = list
            }
            // Sort Dictionary
            for (k,v) in (Array(dict).sorted {$0.key > $1.key}) {
                let item = DataItem(zhangting: k, stocks: v)
                self.dataList.append(item)
            }
        }
        self.addService(dataService: dataService)
    }
    
    private func convertToLayoutData() {
        // 涨停清单
        let dragonCode = self.dataList.first?.stocks.first?.code
        if dragonCode != nil {
            self.dataList.forEach { (item) in
                let items:[ItemData] = item.stocks.map({ (stock) -> ItemData in
                    var sameblocks:[String] = []
                    if stock.code != dragonCode {
                       sameblocks = StockUtils.getSameBlockNames(this: stock.code, that: dragonCode!)
                    }
                    let itemData = ItemData(title: stock.name, data: stock.code, sameblocks: sameblocks,
                                            onItemClicked: { [unowned self] (itemData) in
                                                print(itemData)
                                                self.showLiandongActionSheet(item: itemData)
                    })
                    return itemData
                })
                let layout = LayoutData(title: item.zhangting,data: items)
                self.layoutData.append(layout)
            }
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
                StockUtils.gotoStockViewController(code: item.data!, from: self.navigationController!)
            })
            alertController.addAction(hangqingAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource
extension BigHotBlockViewController: UICollectionViewDataSource {
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
        if item.sameblocks.count > 0 {
            let width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
            cell.contentButton.badgeValue = String(item.sameblocks.count)
            cell.contentButton.badgeOriginX = CGFloat(width-20)
        }
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
            headerView.contentLabel.text = "\(title)"
            headerView.contentLabel.font = UIFont(name: "Arial", size: 18)
            headerView.contentLabel.textColor = UIColor.darkText
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension BigHotBlockViewController: UICollectionViewDelegate {
    
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

extension BigHotBlockViewController: UICollectionViewDelegateFlowLayout {
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


