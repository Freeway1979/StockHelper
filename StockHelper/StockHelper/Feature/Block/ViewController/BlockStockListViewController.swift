//
//  BlockViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import Moya

class BlockStockListViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let shortCellHeight: CGFloat = 68
    let mediumCellHeight: CGFloat = 96
    let longCellHeight: CGFloat = 110
    
    private let today:String = DataCache.getLastDate()
    private let cellID:String = "ZhangTingStockTableViewCell"
    var block:Block2Stocks?;
    private var keyword:String = ""
    var isForBlock: Bool {
        return self.block != nil
    }
    var dragon:ZhangTingStock?
    private var displayedItems:[Stock] = []
    private var stocks:[Stock] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if isForBlock {
            self.title = self.block?.block.name
            self.stocks = self.block?.stocks ?? []
        } else {
            self.title = "股票搜索"
        }
        self.dragon = DataCache.gaoduDragon
        self.tableView.delegate = self;
        self.tableView.dataSource = self
        self.searchBar.delegate = self;
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "ZhangTingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "ZhangTingStockTableViewCell")
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshTableView()
    }
    
    func refreshTableView() -> Void {
        self.refreshTableViewBySearch(keyword: self.keyword)
    }
    
    private func refreshTableViewBySearch(keyword:String) {
        self.keyword = keyword
        var list:[Stock] = []
        var handled:Bool = false
        if (!isForBlock) {
            if (keyword.count < 3) {
                list = []
                handled = true
            }
        }
        let theStocks = isForBlock ? stocks : StockServiceProvider.stocks
        let isChinese = keyword.isIncludeChinese()
        let isCode = keyword.hasPrefix("00")
             || keyword.hasPrefix("30")
             || keyword.hasPrefix("60")
        if (!handled) {
            list = theStocks.filter { (stock) -> Bool in
                var rs = false
                if (keyword.count == 0) {
                    rs = isForBlock ? true : false
                } else {
                    if isChinese {
                        rs = stock.name.contains(keyword)
                    }
                    if isCode {
                        rs = stock.code.contains(keyword)
                    }
                    rs = stock.pinyin.contains(keyword.lowercased())
                        || stock.name.lowercased().contains(keyword.lowercased())
                        || stock.code.contains(keyword)
                }
                return rs;
            }
        }
        let block = self.block?.block;
        self.displayedItems = list.sorted(by: { (lhs:Stock, rhs:Stock) -> Bool in
            let lhsHot:Bool = isForBlock ? StockServiceProvider.isHotStock(stock: lhs, block: block!) : false
            let rhsHot:Bool = isForBlock ? StockServiceProvider.isHotStock(stock: rhs, block: block!) : false
            if lhsHot && !rhsHot {
                return true
            }
            if !lhsHot && rhsHot {
                return false
            }
            return lhs.tradeValue.floatValue < rhs.tradeValue.floatValue
        })
        
        self.tableView.reloadData();
    }
    
    private func isHotStock(stock:Stock) -> Bool {
        if !isForBlock {
           return false
        }
        let block = self.block?.block
        let isHotStock = StockServiceProvider.isHotStock(stock: stock, block: block!)
        return isHotStock
    }
    
    private func gotoViewController(storyboard:String,storyboardId:String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard,bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    func calculateHeight(indexPath:IndexPath) -> CGFloat {
        let stock = self.displayedItems[indexPath.row];
        let s:ZhangTingStock? = DataCache.getZhangTingStock(date: today, code: stock.code)
        var hasExtraBlocks:Bool = false
        let hotblocks:[String] = DataCache.getTopBlockNamesForStock(stock: stock)
        if hotblocks.count > 0 {
            hasExtraBlocks  = true
        }
        if s != nil {
            if dragon != nil && s!.zhangting != dragon?.zhangting {
                let sameblocks = StockUtils.getSameBlockNames(this: stock.code, that: dragon!.code)
                if sameblocks.count > 0 {
                    hasExtraBlocks = true
                }
            } else { //日内龙头
                hasExtraBlocks = true
            }
        }
        if s != nil && hasExtraBlocks { //Line2+Tags
            return longCellHeight
        } else if hasExtraBlocks { //Tags
            return mediumCellHeight
        } else { //Default
            return shortCellHeight
        }
    }
}

extension BlockStockListViewController:UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stock = self.displayedItems[indexPath.row];
        let s:ZhangTingStock? = DataCache.getZhangTingStock(date: today, code: stock.code)
        let view:ZhangTingStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ZhangTingStockTableViewCell
        view.updateModelWithZhangTing(s: s, stock: stock, dragon: dragon, isHot: self.isHotStock(stock: stock))
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.calculateHeight(indexPath: indexPath)
    }
}
extension BlockStockListViewController:UITableViewDelegate {
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
        let row = indexPath.row;
        let stock = self.displayedItems[row]
        print("Stock \(stock.name) clicked")
        StockUtils.gotoStockViewController(code: stock.code, from: self.navigationController!)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if isForBlock {
            let stock = self.displayedItems[indexPath.row]
            let block = self.block?.block
            let isHotStock = self.isHotStock(stock: stock)
            let hotTitle = isHotStock ? "取消热门":"设为热门"
            let setHotAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal,
                                                    title: hotTitle) { [weak self] (rowAction, indexPath) in
                                                        let stock = self!.displayedItems[indexPath.row]
                                                        if isHotStock {
                                                            StockServiceProvider.removeHotStock(stock: stock, block: block!)
                                                        } else {
                                                            StockServiceProvider.setHotStock(stock: stock, block: block!, hotLevel: .Level1)
                                                        }
                                                        self?.tableView?.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            setHotAction.backgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            setHotAction.backgroundColor = UIColor.red
            return [setHotAction]
        }
        return nil
    }
    
}

extension BlockStockListViewController:UISearchBarDelegate {
    
    // MARK:UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.refreshTableViewBySearch(keyword: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Dismiss keyboard
        UIApplication.shared.dismissKeyboard()
        searchBar.text = ""
        self.refreshTableViewBySearch(keyword: "")
    }
}

