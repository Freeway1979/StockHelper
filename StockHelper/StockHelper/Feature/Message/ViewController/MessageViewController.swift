//
//  MessageViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            UISearchBarDelegate {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var keyword:String = ""
    private var messages:[Message] = [];
    private var displayedItems:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchbar.delegate = self
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadData();
   
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
        let message = self.displayedItems[indexPath.row];
        cell?.textLabel!.text = message.displayTitle;
        cell?.detailTextLabel!.text = message.displayStocks;

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
        let message = self.displayedItems[row]
        
        let storyboard = UIStoryboard(name: "Message", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        vc.message = message;
        self.navigationController?.navigationController?.pushViewController(vc, animated: true);
    }
    
    private func reloadTableView(messages:[Message]) {
        self.messages = messages;
        self.refreshTableViewBySearch(keyword: "")
    }
    private func refreshTableViewBySearch(keyword:String) {
        self.displayedItems = messages.filter { (message) -> Bool in
            if (keyword.count == 0) {
                return true
            }
            return message.displayTitle.contains(keyword)
        }
        self.tableView.reloadData();
    }
    
    private func loadData() -> Void {
        MessageServiceProvider.getMessageList { [weak self] (messages) in
            self?.reloadTableView(messages: messages)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
