//
//  MAStrategyViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MAStrategyViewController: UIViewController {

    @IBOutlet weak var ma20Button: UIButton!
    @IBOutlet weak var ma10Button: UIButton!
    @IBOutlet weak var ma5Button: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var predictUpTextField: UITextField!
    @IBOutlet weak var predictMALabel: UILabel!
    @IBOutlet weak var predictMATextField: UITextField!
    
    private var stockCode:String {
        get {
            if (self.codeTextField.text != nil &&
                self.codeTextField.text!.count > 0) {
                return (self.codeTextField.text!)
            }
            return ""
        }
        set {
            self.codeTextField.text! = (newValue)
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
    
    @IBAction func onMATypeButtonClicked(_ sender: UIButton) {
        self.maType = MAType(rawValue: sender.tag)!
        self.setupViews()
        self.calculate()
    }
    
    @IBAction func onCalculateClicked(_ sender: UIButton) {
        self.calculate()
    }
    
    func calculate() {
        //Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        let days = self.maType.rawValue;
        let code = self.stockCode
        if code.count > 0 {
            UIUtils.showLoading()
            let model:StockHQList = StockHQProvider.getStockDayHQ(by: self.stockCode)
            let price = model.predictedMA(predictedChange: self.predictUp, days: days)
            self.predictMAPrice = Float(String(format: "%.2f", price))!;
            UIUtils.dismissLoading()
        }
    }
    
    var maType:MAType = .MA5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews();
    }
    
    
    private func setupViews() -> Void {
        self.predictMALabel.text! = String(format:"预测%d日均线",self.maType.rawValue);
        self.ma5Button.backgroundColor = self.ma5Button.tag == self.maType.rawValue ? UIColor.darkText : UIColor.lightGray
         self.ma10Button.backgroundColor = self.ma10Button.tag == self.maType.rawValue ? UIColor.darkText : UIColor.lightGray
         self.ma20Button.backgroundColor = self.ma20Button.tag == self.maType.rawValue ? UIColor.darkText : UIColor.lightGray
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
