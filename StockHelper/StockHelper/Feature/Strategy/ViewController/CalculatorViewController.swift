//
//  CalculatorViewController.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/6.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupChildViewControllers();
        self.showChildViewController(0);
        
    }
    
    func setupChildViewControllers() -> Void {
        let titles = ["Symmetry","Five Days","Ten Days"];
        for index in 0...2 {
            let storyboard = UIStoryboard(name: "Strategy", bundle: nil)
            let childVC = storyboard.instantiateViewController(withIdentifier: "SymmetryViewController") as! SymmetryViewController
            _ = childVC.view;//This Line is to force View Hierarchy loaded
            childVC.infoText = titles[index];
            self.addChild(childVC);
        }
    }

    @IBAction func onTabButtonClicked(_ sender: UIButton) {
    
        self.showChildViewController(sender.tag);
    
    }
    func showChildViewController(_ tag:Int = 0) -> Void {
        var childView:UIView?
        if (self.view.subviews.count>1) { //First one is StackView
            childView = self.view.subviews[1];
        }
        let childVC = self.children[tag];
        let firstViewFrame = self.view.subviews[0].frame;
        let y = firstViewFrame.origin.y + firstViewFrame.size.height + 20;
        let childRect = CGRect(x: self.view.frame.minX, y: y, width: self.view.frame.width, height: self.view.frame.height - firstViewFrame.size.height);
        childVC.view.frame = childRect;
        
        self.view.addSubview(childVC.view);
        if childView != nil {
            childView?.removeFromSuperview();
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
