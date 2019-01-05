//
//  MainViewController.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/13.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController,ENSideMenuDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // self.removeTabbarItemsText();
        self.sideMenuController()?.sideMenu?.delegate = self
        
        RemoteServiceProvider.getRemoteServerIPAddress { (address) in
            print(address)
            print(RemoteServiceProvider.remoteServerAddress)
        }
        
    }
    
    func removeTabbarItemsText() {
        
        var offset: CGFloat = 6.0
        
        if #available(iOS 11.0, *), traitCollection.horizontalSizeClass == .regular {
            offset = 0.0
        }
        
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0);
            }
        }
    }
    
    @IBAction func onMenuButtonClicked(_ sender: UIBarButtonItem) {
           toggleSideMenuView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }

}
