//
//  MainViewController.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/13.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // self.removeTabbarItemsText();
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
