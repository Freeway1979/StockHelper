//
//  MyMenuViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/5.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    
    private var menuData:[Menu] = []
    
    private struct Menu {
        var title:String
        var storyboardName:String
        var storyboardId:String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMenu()
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0) 
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
    }
    
    private func setupMenu() {
        var menu = Menu(title: "主页", storyboardName: "Main", storyboardId: "MainViewController")
        menuData.append(menu)
        menu = Menu(title: "热门板块", storyboardName: "Block", storyboardId: "HotBlockViewController")
        menuData.append(menu)
        menu = Menu(title: "股票知识", storyboardName: "Study", storyboardId: "StudyTableViewController")
        menuData.append(menu)
        menu = Menu(title: "A股资料", storyboardName: "Document", storyboardId: "DocumentListViewController")
        menuData.append(menu)
        menu = Menu(title: "设置", storyboardName: "Setting", storyboardId: "SettingViewController")
        menuData.append(menu)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.menuData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menu = self.menuData[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.darkGray
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = menu.title
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let menu = self.menuData[indexPath.row]
        let mainStoryboard: UIStoryboard = UIStoryboard(name: menu.storyboardName,bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: menu.storyboardId)

        sideMenuController()?.setContentViewController(destViewController)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}
