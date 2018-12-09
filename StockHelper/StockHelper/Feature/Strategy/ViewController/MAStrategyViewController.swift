//
//  MAStrategyViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MAStrategyViewController: UIViewController {

    @IBOutlet weak var maLabel: UILabel!
    @IBOutlet weak var maTextField: UITextField!
    @IBOutlet weak var lastCloseTextField: UITextField!
    @IBOutlet weak var predictUpTextField: UITextField!
    @IBOutlet weak var predictMALabel: UILabel!
    @IBOutlet weak var predictMATextField: UITextField!
    
    private var maPrice:Float {
        get {
            if (self.maTextField.text != nil &&
                self.maTextField.text!.count > 0) {
                return Float(self.maTextField.text!)!
            }
            return 0
        }
        set {
            self.maTextField.text! = String(newValue)
        }
    }
    private var predictUp:Float {
        get {
            if (self.predictUpTextField.text != nil &&
                self.predictUpTextField.text!.count > 0) {
                return Float(self.predictUpTextField.text!)!
            }
            return 0
        }
        set {
            self.predictUpTextField.text! = String(newValue)
        }
    }
    private var predictMAPrice:Float {
        get {
            if (self.predictMATextField.text != nil &&
                self.predictMATextField.text!.count > 0) {
                return Float(self.predictMATextField.text!)!
            }
            return 0
        }
        set {
            self.predictMATextField.text! = String(newValue)
        }
    }
    private var lastClosePrice:Float {
        get {
            if (self.lastCloseTextField.text != nil &&
                self.lastCloseTextField.text!.count > 0) {
                return Float(self.lastCloseTextField.text!)!
            }
            return 0
        }
        set {
            self.lastCloseTextField.text! = String(newValue)
        }
    }
    
    @IBAction func onCalculateClicked(_ sender: UIButton) {
        let num = self.maType.rawValue;
        var price = Float(num - 1) * self.maPrice;
        price += self.lastClosePrice * Float(1+self.predictUp / 100);
        price = price / Float(num);
        self.predictMAPrice = Float(String(format: "%.2f", price))!;
    }
    
    var maType:MAType = .MA5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews();
    }
    
    private func setupViews() -> Void {
        self.maLabel.text! = String(format:"%d日均线",self.maType.rawValue);
        self.predictMALabel.text! = String(format:"预测%d日均线",self.maType.rawValue);
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
