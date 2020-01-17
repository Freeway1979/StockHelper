//
//  HomeViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD
import WebKit

private let reuseIdentifier = "Cell"

fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let dapanOverviewCollectionViewCell = "DapanOverviewCollectionViewCell"
fileprivate let columns = 4
fileprivate let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
fileprivate let dapanSectionInsets = UIEdgeInsets(top: 1, left: 15, bottom: 1, right: 15)

class HomeViewController: UICollectionViewController {
    //Data Service
    
    @IBOutlet weak var webview: WKWebView!
    var token:String?
    var serviceIndex:Int = 0
    var dataServices: [DataService] = []
    var dataService: DataService?
    //涨停数
    var zts:Int = 0
    //跌停数
    var dts:Int = 0
    //跌幅超过6
    var dds:Int = 0
    
    enum SectionType:Int {
        case DapanOverview = 0
        case QuickActions
        case BlockPeriod
        case HotBlocks
        case HotStocks
        case Xuangu
        case WebSite
        func description() -> String {
            switch self {
            case .DapanOverview: return "大盘概况"
            case .QuickActions: return "快捷方式"
            case .BlockPeriod: return "板块淘金"
            case .HotBlocks: return "人气板块"
            case .HotStocks: return "人气股票"
            case .Xuangu: return "智能选股"
            case .WebSite: return "常用网站"
            }
        }
    }
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
    
    public var dapanOverviewCell:DapanOverviewCollectionViewCell?
    
    private var layoutData:[LayoutData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr1 = ["A","B","C"]
        let arr2 = ["A","B"]
        let set = Set(arrayLiteral: arr1)
        let set2 = Set(arrayLiteral: arr2)
        
        print(set2.isSubset(of: set))
        
        //Data Service
        self.webview.navigationDelegate = self;
        WencaiUtils.prepareWebView(webview: webview);
               
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)
        self.collectionView.register(UINib(nibName:dapanOverviewCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: dapanOverviewCollectionViewCell)
        
        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        
        self.setupLayoutData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.delegate = self;
        // Do any additional setup after loading the view.
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateDragons()
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
        
        
         title = SectionType.DapanOverview.description()
         items.removeAll()
         layout = LayoutData(title: title,data: items)
         self.layoutData.append(layout!)
        
        // Group 0
        title = SectionType.QuickActions.description()
        items.removeAll()
        // Item 1
//        item = ItemData(title: "复盘总结", data:nil, onItemClicked: { itemData in
//            self.gotoViewController(storyboard: "Review", storyboardId: "ReviewDetailViewController")
//        })
//        items.append(item!)
        // Item 2
        item = ItemData(title: "大行情板块", data:nil, onItemClicked: { itemData in
            self.gotoViewController(storyboard: "Block", storyboardId: "BigHotBlockViewController")
        })
        items.append(item!)
        
        // Item 1
        item = ItemData(title: "板块周期表", data:nil, onItemClicked: { itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "BlockCycleViewController")
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "热门板块",data: nil,onItemClicked: {itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "HotBlockViewController")
        })
        items.append(item!)
        
        // Item 1
        item = ItemData(title: "股票搜索", data: nil,onItemClicked: { itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "BlockStockListViewController")
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 3
        title = SectionType.WebSite.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "问财选股", data: WebSite.WenCai, onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "北向资金", data: WebSite.NorthMoney, onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 3
        item = ItemData(title: "涨跌温度计", data: WebSite.ZhangDieTing, onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 4
        item = ItemData(title: "限售解禁", data: WebSite.JieJin, onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 5
        item = ItemData(title: "新股上市", data: WebSite.NewStock, onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
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
    
    func showQingXuListActionSheet() {
        DispatchQueue.main.async { // 主线程执行
            let alertController = UIAlertController(title: "选择情绪周期", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:{ (action) -> Void in
                print("cancelled")
            })
            alertController.addAction(cancelAction)
            
            let list = ChaoDuanQingXu.allValues
            list.forEach { (qx) in
                let action = UIAlertAction(title:qx.rawValue, style: .default, handler:{ [unowned self] (action) -> Void in
                    self.dapanOverviewCell?.updateChaoDuanQingXu(qingxu: qx.rawValue)
                })
                alertController.addAction(action)
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var loadingCount = 0
    func showLoading() {
        if loadingCount < 0 {
            loadingCount = 0
        }
        if loadingCount == 0 {
            DispatchQueue.main.async(execute: {
                ZKProgressHUD.show()
            })
        }
        loadingCount = loadingCount + 1
    }
    func hideLoading() {
        loadingCount = loadingCount - 1
        if loadingCount == 0 {
            DispatchQueue.main.async(execute: {
                ZKProgressHUD.dismiss()
            })
        }
    }
    
    func updateDragons() {
        let overview = DapanOverview.sharedInstance
        DispatchQueue.main.async { [unowned self] in
            self.dapanOverviewCell?.applyModel(overviewText: overview.overviewTex, status: overview.dapanStatus, badge: overview.dapanStatusBadge, action: overview.sugguestAction, cangwei: overview.sugguestCangWei)
            self.dapanOverviewCell?.updateDragons(marketDragon: DataCache.marketDragon, gaoduDragon: DataCache.gaoduDragon)
            self.dapanOverviewCell?.onDragonClicked = { [unowned self] (tag) in
                let code:String? = tag == 1 ? DataCache.marketDragon?.code : DataCache.gaoduDragon?.code
                if code != nil {
                    StockUtils.gotoStockViewController(code: code!, from: (self.navigationController?.navigationController)!)
                }
            }
        }
    }
    
    func refreshDapanOverview() {
        let dataService = ZhangDieTingDataService(date: Date().formatWencaiDateString(), keywords: "(跌幅大于6的股票或涨跌停数)且非ST非科创板", title: "(跌幅大于6的股票或涨跌停数)且非ST非科创板")
        dataService.onComplete = { [unowned self] (data) in
            let list:[String] = data as! [String]
            self.zts = 0
            self.dts = 0
            self.dds = 0
            list.forEach { (item) in
                if item == "涨停" {
                    self.zts = self.zts + 1
                } else if item == "跌停" {
                    self.dts = self.dts + 1
                } else {
                    self.dds = self.dds + 1
                }
            }
            self.dts = 13
            self.dds = 45
            self.dapanOverviewCell?.updateZhangDieTingShu(zts: "\(self.zts)", dts: "\(self.dts)", dtsBadge: self.dts >= 10 ? "危险":nil, dds: "\(self.dds)", ddsBadge: self.dds >= 40 ? "危险":nil)
            WencaiUtils.loadWebPage(with: WebSite.NorthMoney, webview: self.webview)
        }
        self.addService(dataService: dataService)
        self.runService(webView: self.webview, dataService: dataService)
        
//        _ = DapanOverview.sharedInstance.getHQListFromServer(code: "000001", startDate: "", endDate: "")
        
        self.updateDragons()
    }
    
    func onNorthMoneyHandled(northMoney:[String]) {
        self.hideLoading()
        if northMoney.count > 2 {
            self.dapanOverviewCell?.updateNorthMoney(hgt: northMoney[0], sgt: northMoney[1], northMoney: northMoney[2])
        }
    }

    func loadData() -> Void {
        let myQueue = DispatchQueue(label: "initData")
        let group = DispatchGroup()
        
        self.showLoading()
        
        self.refreshDapanOverview()
        // 1
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 1")
            StockServiceProvider.getBasicData()
            StockServiceProvider.buildBlock2StocksCodeMap()
        })
        // 2
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 2")
            // 股票基本信息列表
        })
        
        // all
        group.notify(queue: myQueue) { [unowned self] in
            print("notify")
            self.hideLoading()
        }
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.layoutData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == SectionType.DapanOverview.rawValue {
            return 1
        }
        return self.layoutData[section].data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let group = self.layoutData[section]
        if section == SectionType.BlockPeriod.rawValue
            || section == SectionType.HotBlocks.rawValue
            || section == SectionType.HotStocks.rawValue
            || section == SectionType.WebSite.rawValue
            || section == SectionType.QuickActions.rawValue
        {
            let item = group.data[row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
                as! TagCollectionViewCell
            cell.contentButton.text = item.title
            
            cell.onClicked = { () -> Void in
                print("Button clicked:\(cell.contentButton.text!)")
                item.onItemClicked(item)
            }
            // Configure the cell
            
            return cell
        }

        if section == SectionType.DapanOverview.rawValue
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dapanOverviewCollectionViewCell, for: indexPath)
                as! DapanOverviewCollectionViewCell
            cell.onClicked = { [unowned self] () in
                StockUtils.openDapanHQPage(code: WebSite.Dapan_SH, name: "上证指数", from: (self.navigationController?.navigationController)!)
            }
            cell.onQingXuClicked = { [unowned self] () in
                self.showQingXuListActionSheet()
            }
            self.dapanOverviewCell = cell
            // Configure the cell
            return cell
        }
        
        // never go here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
        return cell
    }
    
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let group = self.layoutData[indexPath.section]
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerReuseIdentifier,
                                                                             for: indexPath) as! HeaderCollectionView
            headerView.contentLabel.text = group.title
            
            if indexPath.section == SectionType.DapanOverview.rawValue {
                headerView.hideAction = false
                headerView.onActionButtonClicked = { [unowned self] () in
                    self.showLoading()
                    self.refreshDapanOverview()
                }
            }
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension HomeViewController {
    
    //      Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //      Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == SectionType.DapanOverview.rawValue {
            return
        }
        let row = indexPath.row
        let item = self.layoutData[section].data[row]
        print(item)
    }
    
    //      Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == SectionType.DapanOverview.rawValue {
            let screenWidth = UIScreen.main.bounds.size.width;
            return CGSize(width: screenWidth, height: 254)
        }
   
        let height = Theme.CellView.height
        var width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
        if width < Int(Theme.TagButton.width) {
            width = Int(Theme.TagButton.width)
        }
        return CGSize(width: width, height: Int(height))
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == SectionType.DapanOverview.rawValue {
            return dapanSectionInsets
        }
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


