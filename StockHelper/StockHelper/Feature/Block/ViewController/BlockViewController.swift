//
//  BlockViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import Moya

class BlockViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
    UISearchBarDelegate
{
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var blocks:[Block] = [];
    private var keyword:String = ""
    private var displayedItems:[Block] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self
        self.searchbar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        StockServiceProvider.getBlockList {[weak self] (blocks) in
            self?.refreshTableView(blocks: blocks)
        }
    }
    
    func refreshTableView(blocks:[Block]) -> Void {
        self.blocks = blocks;
        self.refreshTableViewBySearch(keyword: "")
    }
    
    private func refreshTableViewBySearch(keyword:String) {
        let isChinese = keyword.isIncludeChinese()
        self.displayedItems = blocks.filter { (block) -> Bool in
            if (keyword.count == 0) {
                return true
            }
            if isChinese {
                return block.name.contains(keyword)
            }
            let isCode = keyword.hasPrefix("00")
                || keyword.hasPrefix("30")
                || keyword.hasPrefix("88")
                || keyword.hasPrefix("60")
            if isCode {
                return block.code.contains(keyword)
            }
            return block.pinyin.contains(keyword.lowercased())
        }
        self.tableView.reloadData();
    }
    
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
        let cellId = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell (style: .subtitle, reuseIdentifier: cellId)
        }
        // Configure the cell...
        let block = self.displayedItems[indexPath.row];
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = block.name;
        cell?.detailTextLabel?.text = self.getBlockSubtitle(block: block)
        
        return cell!
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
        let basicBlock = self.displayedItems[row]
        print("Block \(basicBlock.name) clicked")

        let block = StockServiceProvider.getSyncBlockStocksDetail(basicBlock: basicBlock)
        self.gotoBlockStockListScreen(block: block)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let block = self.displayedItems[indexPath.row]
        let isImportantBlock = StockServiceProvider.isImportantBlock(block: block)
        let isHotBlock = StockServiceProvider.isHotBlock(block: block)
        let importantTitle = isImportantBlock ? "取消重点":"设为重点"
        let hotTitle = isHotBlock ? "取消热门":"设为热门"
        let setImportantAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal,
                                                title: importantTitle) {[weak self] (rowAction, indexPath) in
                                                    let block = self!.displayedItems[indexPath.row]
                                                    if isImportantBlock {
                                                        StockServiceProvider.removeImportantBlock(block: block)
                                                    } else {
                                                        StockServiceProvider.setImportantBlock(block: block, importantLevel: .Level1)
                                                    }
                                                    self?.tableView?.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                                    
        }
        setImportantAction.backgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        setImportantAction.backgroundColor = UIColor.orange
        
        let setHotAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal,
                                                title: hotTitle) { [weak self] (rowAction, indexPath) in
                                                    let block = self!.displayedItems[indexPath.row]
                                                    if isHotBlock {
                                                        StockServiceProvider.removeHotBlock(block: block)
                                                    } else {
                                                         StockServiceProvider.setHotBlock(block: block, hotLevel: .Level1)
                                                    }
                                                    self?.tableView?.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        setHotAction.backgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        setHotAction.backgroundColor = UIColor.red
        return [setHotAction,setImportantAction]
    }
    
    private func gotoBlockStockListScreen(block:Block2Stocks) {
        let storyboard = UIStoryboard(name: "Block", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BlockStockListViewController") as! BlockStockListViewController
        vc.block = block;
        self.navigationController?.navigationController?.pushViewController(vc, animated: true);
    }
    
    private func getBlockSubtitle(block:Block) -> String {
        let code = block.code
        let type = block.type.localizedString
        let hotblock = StockServiceProvider.getHotBlock(blockcode: code)
        var rs = "\(code) \(type)"
        if (hotblock != nil) {
            if (hotblock?.hotLevel != .NoLevel) {
                rs = "\(rs) 热门"
            }
            if (hotblock?.importantLevel != .NoLevel) {
                rs = "\(rs) 重点"
            }
        }
        return rs
    }
    
    // MARK:UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.refreshTableViewBySearch(keyword: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.refreshTableViewBySearch(keyword: "")
    }
}

