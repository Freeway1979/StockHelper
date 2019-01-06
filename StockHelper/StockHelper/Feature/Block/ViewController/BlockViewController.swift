//
//  BlockViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import Moya

class BlockViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    private var tableView:UITableView?;
    private var blocks:[Block] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect:CGRect = self.view.bounds;
        let tableView = UITableView(frame: rect)
        tableView.delegate = self;
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        // Do any additional setup after loading the view, typically from a nib.
        
        StockServiceProvider.getBlockList {[weak self] (blocks) in
            self?.refreshTableView(blocks: blocks)
        }
    }
    
    func refreshTableView(blocks:[Block]) -> Void {
//        //Sort blocks
//        let sorted = blocks.sorted { (b1, b2) -> Bool in
//            let hotblock1 = StockServiceProvider.getHotBlock(blockcode: b1.code)
//            let hotblock2 = StockServiceProvider.getHotBlock(blockcode: b2.code)
//            let hb1 = hotblock1 == nil ? "B":"A"
//            let hb2 = hotblock2 == nil ? "B":"A"
//            if (hotblock1 ==  nil && hotblock2 != nil) {
//                return false
//            }
//            if (hotblock1 !=  nil && hotblock2 == nil) {
//                return true
//            }
//            let hblevel1 = hotblock1!.hotLevel == .NoLevel ? "A": String(hotblock1!.hotLevel.rawValue)
//        }
//        self.blocks = sorted;
        self.blocks = blocks
        self.tableView!.reloadData()
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.blocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell (style: .subtitle, reuseIdentifier: cellId)
        }
        // Configure the cell...
        let block = self.blocks[indexPath.row];
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
        let basicBlock = self.blocks[row]
        print("Block \(basicBlock.name) clicked")

        let block = StockServiceProvider.getSyncBlockStocksDetail(basicBlock: basicBlock)
        self.gotoBlockStockListScreen(block: block)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let setImportantAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal,
                                                title: "设为重点") {[weak self] (rowAction, indexPath) in
                                                    let block = self!.blocks[indexPath.row]
            StockServiceProvider.setImportantBlock(block: block, importantLevel: .Level1)
                                                    self?.tableView?.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                                    
        }
        setImportantAction.backgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        setImportantAction.backgroundColor = UIColor.orange
        
        let setHotAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal,
                                                title: "设为热门") { [weak self] (rowAction, indexPath) in
                                                    let block = self!.blocks[indexPath.row]
          StockServiceProvider.setHotBlock(block: block, hotLevel: .Level1)
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
    
}

