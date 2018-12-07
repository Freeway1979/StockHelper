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
    @IBOutlet weak var info: UILabel!
    
    var infoText: String? {
        get {
            return self.info.text!;
        }
        set {
            self.info.text! = newValue!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCalculateClicked(_ sender: UIButton) {
        
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
