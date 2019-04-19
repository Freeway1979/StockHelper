//
//  SelectedStocksViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/18.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let columns = 5
fileprivate let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

class SelectedStocksViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var keyword:String = ""
    private var blocks:[Block2Stocks] = []
    private var displayedItems:[Block2Stocks] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.searchBar.delegate = self;
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)

        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        //        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
        
        self.title = "智能选股"
        self.prepareData()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func prepareData() {
       
        StockServiceProvider.getXuanguData { [weak self] (stockcodes) in
            var blocks:[String:[String]] = [:]
            for code in stockcodes {
                let blockcodes:[String] = StockServiceProvider.getBlockCodeList(of: code)
                for blockcode in blockcodes {
                    var stocks:[String] = blocks[blockcode] ?? []
                    stocks.append(code)
                    blocks.updateValue(stocks, forKey: blockcode)
                }
            }
        
            var block2stocksList:[Block2Stocks] = []
            for item in blocks {
                let block = StockServiceProvider.getBlock(by: item.key)
                let block2stocks = Block2Stocks(block: block)
                for stockcode in item.value {
                    let stock = StockServiceProvider.getStock(by: stockcode)
                    block2stocks.stocks?.append(stock)
                }
                block2stocksList.append(block2stocks)
            }
            
            block2stocksList.sort(by: { (lhs, rhs) -> Bool in
                return lhs.stocks!.count > rhs.stocks!.count
            })
            self?.blocks = block2stocksList
            self?.displayedItems = self?.blocks ?? []
            self?.refreashCollectionViewData()
        }
        
        self.refreashCollectionViewData()
    }
    
    private func refreashCollectionViewData() {
        self.refreshCollectionViewBySearch(keyword: "")
    }
    
    private func refreshCollectionViewBySearch(keyword:String) {
        self.keyword = keyword
        let isChinese = keyword.isIncludeChinese()
        let isCode = keyword.hasPrefix("00")
            || keyword.hasPrefix("30")
            || keyword.hasPrefix("60")
        
        var list = self.blocks.filter { (block2stocks) -> Bool in
            var rs = false
            let block = block2stocks.block
            if (keyword.count == 0) {
                rs = true
            } else {
                if isChinese {
                    rs = block.name.contains(keyword)
                }
                if isCode {
                    rs = block.code.contains(keyword)
                }
                rs = block.pinyin.contains(keyword.lowercased())
                    || block.name.lowercased().contains(keyword.lowercased())
                    || block.code.contains(keyword)
            }
            return rs;
        }
        list.sort(by: { (lhs, rhs) -> Bool in
            return lhs.stocks!.count > rhs.stocks!.count
        })
        self.displayedItems = list
        self.collectionView.reloadData();
    }
   
}

// MARK: UICollectionViewDataSource
extension SelectedStocksViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.displayedItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayedItems[section].stocks!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = self.displayedItems[section].stocks![row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
            as! TagCollectionViewCell
        
        cell.contentButton.style = .Default
        cell.contentButton.text = item.name
        cell.contentButton.userInfo = item
        cell.contentButton.setTextStyle(textStyle: .medium)
        
        cell.onClicked = { () -> Void in
            print("Button clicked:\(cell.contentButton.text!)")
            
        }
        // Configure the cell
        
        return cell
        
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath)
        //        let label = UILabel(frame: CGRect(x: 15, y: 15, width: 200, height: 30))
        //        label.text = headerTitles[indexPath.section]
        //        view.addSubview(label)
        //        return view
        let block = self.displayedItems[indexPath.section]
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerReuseIdentifier,
                                                                             for: indexPath) as! HeaderCollectionView
            headerView.contentLabel.text = block.block.name
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension SelectedStocksViewController:UICollectionViewDelegate {
    
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
        let item = self.displayedItems[section].stocks![row]
        Utils.openTHS(with: item.code)
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

extension SelectedStocksViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 24)
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
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


extension SelectedStocksViewController:UISearchBarDelegate {
    
    // MARK:UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.refreshCollectionViewBySearch(keyword: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Dismiss keyboard
        UIApplication.shared.dismissKeyboard()
        searchBar.text = ""
        self.refreshCollectionViewBySearch(keyword: "")
    }
}
