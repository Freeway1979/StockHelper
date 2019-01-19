//
//  HomeViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController {
    private enum LayoutKey:String {
        case HotBlocks = "人气板块"
        case ImportantBlocks = "重点板块"
        case HotStocks = "人气股票"
    }
    private class LayoutData {
        var key:LayoutKey
        var title:String = ""
        var data: [Any] = []
        init(key:LayoutKey,title:String,data:[Any]) {
            self.key = key
            self.title = title
            self.data = data
        }
    }
    
    private var layoutData:[LayoutData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.setupLayoutData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        loadData()
        
//        testGroup();
    }
    
    private func setupLayoutData() {
        var layout = LayoutData(key: .HotBlocks,
                                title: LayoutKey.HotBlocks.rawValue,
                                data: [])
        self.layoutData.append(layout)
        layout = LayoutData(key: .HotStocks,
                            title: LayoutKey.HotStocks.rawValue,
                            data: [])
        self.layoutData.append(layout)
        layout = LayoutData(key: .ImportantBlocks,
                            title: LayoutKey.ImportantBlocks.rawValue,
                            data: [])
        self.layoutData.append(layout)
    }
    private func getLayoutData(for key:LayoutKey) -> LayoutData? {
        for item in self.layoutData {
            if item.key == key {
                return item
            }
        }
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func reloadData() {
        self.collectionView.reloadData()
    }
        
    func loadData() -> Void {
        let myQueue = DispatchQueue(label: "initData")
        let group = DispatchGroup()
        
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            ZKProgressHUD.show()
        })
     
        // 1
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 1")
            // 板块基本信息列表
            StockServiceProvider.getBlockList { [weak self] (blocks) in
                print("getBlockList",blocks.count)
                let layout = self?.getLayoutData(for: .HotBlocks)
                layout?.data = StockServiceProvider.getSyncHotBlocks()
                self?.reloadData()
            }
        })
        // 2
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 2")
            // 股票基本信息列表
            StockServiceProvider.getStockList { [weak self] (stocks) in
                print("getStockList",stocks.count)
                let layout = self?.getLayoutData(for: .HotStocks)
                layout?.data = StockServiceProvider.getSyncHotStocks()
                self?.reloadData()
            }
        })
        // 3
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 3")
            // 板块和股票映射关系(code)
            StockServiceProvider.getSimpleBlock2StockList {
                print("getSimpleBlock2StockList")
            }
        })
        // 4
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 4")
            // 股票和板块映射关系(code)
            StockServiceProvider.getSimpleStock2BlockList {
                print("getSimpleStock2BlockList")
            }
        })
        
        // 5
        group.notify(queue: myQueue) {
            print("notify")
            
            DispatchQueue.main.async(execute: {
                print(Thread.isMainThread)
                ZKProgressHUD.dismiss()
                //ZKProgressHUD.showSuccess()
            })
        }
       
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.layoutData.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let layout = self.layoutData[section]
        return layout.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let layout = self.layoutData[indexPath.section]
        let item = layout.data[indexPath.row]
        
        print(item)
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

}
