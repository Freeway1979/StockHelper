//
//  PriceGridViewController.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/13.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class PriceGridViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var bottomLowTextField: UITextField!
    @IBOutlet weak var topHighTextField: UITextField!
    
    private var highPrice:Float {
        get {
            if (self.topHighTextField.text != nil &&
                self.topHighTextField.text!.count > 0) {
                return Float(self.topHighTextField.text!)!
            }
            return 0
        }
        set {
            self.topHighTextField.text! = String(newValue)
        }
    }
    private var lowPrice:Float {
        get {
            if (self.bottomLowTextField.text != nil && self.bottomLowTextField.text!.count > 0) {
                return Float(self.bottomLowTextField.text!)!
            }
            return 0
        }
        set {
            self.bottomLowTextField.text! = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onCalculateClicked(_ sender: UIButton) {
        let highPrice = self.highPrice;
        let lowPrice = self.lowPrice;
        let delta = highPrice-lowPrice;
        let price75 = lowPrice + delta * 0.75;
        let price50 = lowPrice + delta * 0.5;
        let price33 = lowPrice + delta / 3.0;
        let price25 = lowPrice + delta * 0.25;
        var result = "100%              \(highPrice.dot2String) \n";
           result += "75%                 \(price75.dot2String) \n";
           result += "50%                 \(price50.dot2String) \n";
           result += "33.3%             \(price33.dot2String) \n";
           result += "25%                 \(price25.dot2String) \n";
           result += "Base                \(lowPrice.dot2String) ";
        self.resultLabel.text! = result;
        //Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
