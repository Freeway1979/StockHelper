//
//  HomeViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

private let reuseIdentifier = "Cell"

fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let columns = 4
fileprivate let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)


class HomeViewController: UICollectionViewController {
    enum SectionType:Int {
        case QuickActions = 0
        case BlockPeriod
        case HotBlocks
        case HotStocks
        case Xuangu
        case WebSite
        func description() -> String {
            switch self {
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
    
    private var layoutData:[LayoutData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)
        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        
        self.setupLayoutData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.delegate = self;
        // Do any additional setup after loading the view.
        loadData()
        
//        testGroup();
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
        
        
        // Group 0
        title = SectionType.QuickActions.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "复盘总结", data:nil, onItemClicked: { itemData in
            self.gotoViewController(storyboard: "Review", storyboardId: "ReviewDetailViewController")
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "涨停排行榜", data:nil, onItemClicked: { itemData in
            self.gotoViewController(storyboard: "Block", storyboardId: "ZhangTingListViewController")
        })
        items.append(item!)
    
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 1
        title = SectionType.BlockPeriod.description()
        items.removeAll()
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
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 2
        title = SectionType.Xuangu.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "自定义选股", data: nil,onItemClicked: { itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "SelectedStocksViewController")
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 3
        title = SectionType.WebSite.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "问财选股", data: "https://www.iwencai.com", onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "北向资金", data: "http://data.eastmoney.com/hsgt/index.html", onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 3
        item = ItemData(title: "涨跌温度计", data: "http://stock.jrj.com.cn/tzzs/zdtwdj.shtml", onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 4
        item = ItemData(title: "限售解禁", data: "http://data.10jqka.com.cn/market/xsjj/", onItemClicked: { [weak self] itemData in
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
        
    func loadData() -> Void {
        
        let myQueue = DispatchQueue(label: "initData")
        let group = DispatchGroup()
        
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            ZKProgressHUD.show()
        })
     
        // 1
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 1")
            // 板块基本信息列表
            StockServiceProvider.getBlockList { [weak self] (blocks) in
                print("getBlockList",blocks.count)
//                let layout = self?.getLayoutData(for: .HotBlocks)
//                layout?.data = StockServiceProvider.getSyncHotBlocks()
//                self?.reloadData()
            }
        })
        // 2
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 2")
            // 股票基本信息列表
            StockServiceProvider.getStockList { [weak self] (stocks) in
                print("getStockList",stocks.count)
//                let layout = self?.getLayoutData(for: .HotStocks)
//                layout?.data = StockServiceProvider.getSyncHotStocks()
//                self?.reloadData()
            }
        })
        // 3
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 3")
            // 板块和股票映射关系(code)
            StockServiceProvider.getSimpleBlock2StockList {
                print("getSimpleBlock2StockList")
            }
        })
        // 4
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 4")
            // 股票和板块映射关系(code)
            StockServiceProvider.getSimpleStock2BlockList {
                print("getSimpleStock2BlockList")
            }
        })
        // 5
//        myQueue.async(group: group, qos: .default, flags: [], execute: {
//            print("task 5")
//            THSDataProvider.getJieJinStockList(callback: { (stocks) in
//                print(stocks)
//            })
//        })
        // all
        group.notify(queue: myQueue) {
            print("notify")
            
            DispatchQueue.main.async(execute: {
                print(Thread.isMainThread)
                ZKProgressHUD.dismiss()
                //ZKProgressHUD.showSuccess()
            })
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
    //let screenWidth = UIScreen.main.bounds.size.width;
        let height = Theme.CellView.height
        var width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
        if width < Int(Theme.TagButton.width) {
            width = Int(Theme.TagButton.width)
        }
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


