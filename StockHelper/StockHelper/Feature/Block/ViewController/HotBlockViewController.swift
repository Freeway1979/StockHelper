//
//  HotBlockViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/10.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import ObjectiveC


fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let stockReuseIdentifier = "StockCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let columns = 4
fileprivate let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
fileprivate let stockSectionInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

// MARK: add selected to hot block item
// Declare a global var to produce a unique address as the assoc object handle
private var AssociatedObjectHandle: UInt8 = 0

extension HotBlock {
    var selected: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class HotBlockViewController: UICollectionViewController {
    
    enum SectionType:Int {
        case hotBlock = 0
        case associatedStocks = 1
    }
    
    private var hotblocks:[HotBlock] = []
    private var associatedStocks:[Stock2Blocks] = []

    public var liandongStockCode:String?
    
    private var headerTitles = ["概念板块","关联股票"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)
        self.collectionView.register(UINib(nibName:stockReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: stockReuseIdentifier)
        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
//        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
        
        self.prepareData()
        
        
        // Do any additional setup after loading the view.
    }

    private func getHotBlocksFromStock(code:String) -> [HotBlock] {
        let stock:Stock = StockServiceProvider.getStock(by: code)
        let gnList:[String] = stock.gnList
        var blocks:[HotBlock] = []
        for gn in gnList {
            let block = StockUtils.getBlockByName(gn)
            if (block != nil) {
                let hotblock = HotBlock(block: block!)
                hotblock.hotLevel = HotLevel.Level1
                blocks.append(hotblock)
            }
        }
        return blocks
    }
    private func getHotBlocksFromBlockCycle() -> [HotBlock] {
        let names:[String] = DataCache.getTopBlockNames()
        var blocks:[HotBlock] = []
        var count = 0
        names.forEach({ name in
            let block = StockUtils.getBlockByName(name)
            if (block != nil && count < 10) {
                let hotblock = HotBlock(block: block!)
                hotblock.hotLevel = HotLevel.Level1
                blocks.append(hotblock)
                count = count + 1
            }
        })
        return blocks
    }
    private func prepareData() {
       let isLiandong:Bool = self.liandongStockCode != nil;
        if isLiandong {
            self.hotblocks = self.getHotBlocksFromStock(code: self.liandongStockCode!)
            self.title = "股票联动"
        }
        else {
            self.hotblocks = StockUtils.getHotBlocks()
            let blocks = self.getHotBlocksFromBlockCycle()
            // 去重
            blocks.forEach { [unowned self] (block) in
                let foundBlock = self.hotblocks.first(where: { (bb) -> Bool in
                    return bb.block.code == block.block.code
                })
                if (foundBlock == nil) {
                    self.hotblocks.append(block)
                }
            }
            for item in self.hotblocks {
                item.selected = false
            }
        }
       self.refreashCollectionViewData()
    }
    
    private func refreashCollectionViewData() {
        let selectedHotblocks = hotblocks.filter({ (block) -> Bool in
            return block.selected
        })
        self.associatedStocks = StockUtils.getAssociatedStockList(of: selectedHotblocks)
        self.collectionView.reloadData()
    }
    
    private func toggleHotBlock(of block:HotBlock?) {
        block?.selected = !(block?.selected)!
        self.refreashCollectionViewData()
    }
}

// MARK: UICollectionViewDataSource
extension HotBlockViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == SectionType.hotBlock.rawValue {
            return self.hotblocks.count
        }
        else if (section == SectionType.associatedStocks.rawValue) {
            return self.associatedStocks.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == SectionType.hotBlock.rawValue {
            let item = self.hotblocks[row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
                as! TagCollectionViewCell
            
            cell.contentButton.style = item.selected ? .Primary : .Default
            
            cell.contentButton.text = item.block.name
            
            cell.contentButton.userInfo = item
            
            cell.onClicked = { () -> Void in
                print("Button clicked:\(cell.contentButton.text!)")
                self.toggleHotBlock(of: item)
            }
            // Configure the cell
            
            return cell
        }
        else if (section == SectionType.associatedStocks.rawValue) {
            let item = self.associatedStocks[row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stockReuseIdentifier, for: indexPath)
                as! StockCollectionViewCell
            cell.stockNameLabel.text = item.name
            cell.codeLabel.text = "\(item.code)      流通值:\(item.formatMoney)"
            return cell
        }
        
        // never go here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stockReuseIdentifier, for: indexPath)
        return cell
    }
    
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath)
//        let label = UILabel(frame: CGRect(x: 15, y: 15, width: 200, height: 30))
//        label.text = headerTitles[indexPath.section]
//        view.addSubview(label)
//        return view
        
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerReuseIdentifier,
                                                                             for: indexPath) as! HeaderCollectionView
            headerView.contentLabel.text = headerTitles[indexPath.section]
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension HotBlockViewController {
    
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
        if (section == SectionType.associatedStocks.rawValue) {
            let item = self.associatedStocks[row]
            StockUtils.openStockHQPage(code: item.code, name: item.name, from: self.navigationController!)
        }
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

extension HotBlockViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width;
        let height = Theme.CellView.height
        var width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
        if width < Int(Theme.TagButton.width) {
            width = Int(Theme.TagButton.width)
        }
        if indexPath.section == SectionType.associatedStocks.rawValue {
            return CGSize(width: screenWidth, height: 60)
        }
        return CGSize(width: width, height: Int(height))
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == SectionType.associatedStocks.rawValue {
            return stockSectionInsets
        }
        return sectionInsets
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == SectionType.hotBlock.rawValue {
            return 10
        }
        return 0
    }
    
    // 5
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: CGFloat(Theme.CollectionHeaderView.height))
    }
}

