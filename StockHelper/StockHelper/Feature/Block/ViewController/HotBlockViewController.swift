//
//  HotBlockViewController.swift
//  HelloCollectionView
//
//  Created by andyli2 on 2019/1/10.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "StockCollectionViewCell"
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)


class HotBlockViewController: UICollectionViewController {
    
    private var displayedItems:[Stock] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(UINib(nibName: "StockCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        self.displayedItems = self.prepareData()
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    private func prepareData() -> [Stock] {
        var ss:[Stock] = []
        for i in 10...40 {
            let stock = Stock(code: "3000\(i)", name: "名字\(i)")
            ss.append(stock)
        }
        return ss;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: UICollectionViewDataSource
extension HotBlockViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.displayedItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.displayedItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as! StockCollectionViewCell
        
        cell.bgColor = indexPath.row % 2 == 0 ? UIColor.red : UIColor.orange
        cell.textColor = UIColor.white
        cell.text = item.name
     
        cell.onClicked = { () -> Void in
            print("Button clicked:\(cell.text!)")
        }
        // Configure the cell
        
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension HotBlockViewController {
    
    //      Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    //      Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    //      Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
}

extension HotBlockViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
