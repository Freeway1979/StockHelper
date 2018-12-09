//
//  SymmetryViewController.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/6.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class SymmetryViewController: UIViewController {
    @IBOutlet weak var previousHighPriceTextField: UITextField!
    @IBOutlet weak var bottomLowPriceTextField: UITextField!
    @IBOutlet weak var estimatedTopPriceTextField: UITextField!
    
    private var highPrice:Float {
        get {
            if (self.previousHighPriceTextField.text != nil &&
                self.previousHighPriceTextField.text!.count > 0) {
                return Float(self.previousHighPriceTextField.text!)!
            }
            return 0
        }
        set {
            self.previousHighPriceTextField.text! = String(newValue)
        }
    }
    private var lowPrice:Float {
        get {
            if (self.bottomLowPriceTextField.text != nil && self.bottomLowPriceTextField.text!.count > 0) {
                return Float(self.bottomLowPriceTextField.text!)!
            }
            return 0
        }
        set {
            self.bottomLowPriceTextField.text! = String(newValue)
        }
    }
    private var topHighPrice:Float {
        get {
            if (self.estimatedTopPriceTextField.text != nil) {
                return Float(self.estimatedTopPriceTextField.text!)!
            }
            return 0
        }
        set {
            self.estimatedTopPriceTextField.text! = String(newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.highPrice = 0
//        self.lowPrice = 0
//        self.topHighPrice = 0
    }
    
    @IBAction func onCalculateClicked(_ sender: UIButton) {
        let price = self.highPrice * 2 - self.lowPrice;
        self.topHighPrice = Float(String(format: "%.2f", price))!
    }
    
    func setupViews() -> Void {
         
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
