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
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
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
        self.blocks = blocks;
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        let block = self.blocks[indexPath.row];
        cell.textLabel!.text = "\(block.code) \(block.name)";
        
        return cell
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
    
    private func gotoBlockStockListScreen(block:Block2Stocks) {
        let storyboard = UIStoryboard(name: "Block", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BlockStockListViewController") as! BlockStockListViewController
        vc.block = block;
        self.navigationController?.navigationController?.pushViewController(vc, animated: true);
    }
    
}

