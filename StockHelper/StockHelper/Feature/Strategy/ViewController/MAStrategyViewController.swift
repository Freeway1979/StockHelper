//
//  MAStrategyViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MAStrategyViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var predictUpTextField: UITextField!
    @IBOutlet weak var predictMALabel: UILabel!
    @IBOutlet weak var predictMATextField: UITextField!
    
    @IBOutlet weak var predictMAResultLabel: UILabel!
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
    
    @IBAction func onCalculateClicked(_ sender: UIButton) {
        self.calculate()
    }
    
    func calculate() {
        //Dismiss keyboard
        UIApplication.shared.dismissKeyboard()
        let code = self.stockCode
        var mas: String = ""
        if code.count > 0 {
            UIUtils.showLoading()
            let model:StockHQList = StockHQProvider.getStockDayHQ(by: self.stockCode)
            
            MAType.allCases.forEach {
                let days = ($0.rawValue)
                let price = model.predictedMA(predictedChange: self.predictUp, days: days)
                let predictMAPrice = String(format: "   %d日预测均价:%.2f",days, price);
                mas = "\(mas)\n\(predictMAPrice)\n"
            }
            
            let (zt,dt) = model.zhangDieTingPrice()
            let ztStr = String(format: "   涨停价:%.2f", zt);
            mas = "\(mas)\n\(ztStr)\n"
            let dtStr = String(format: "   跌停价:%.2f", dt);
            mas = "\(mas)\n\(dtStr)\n"
            
            self.predictMAResultLabel.text = mas;
        
            UIUtils.dismissLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews();
    }
    
    
    private func setupViews() -> Void {
        self.predictMALabel.text! = "预测价格";
        self.predictUp = 10
        let label = self.predictMAResultLabel!;
        label.layer.masksToBounds = true;
        label.layer.cornerRadius = 10;
        label.layer.borderColor = UIColor.lightGray.cgColor;
        label.layer.borderWidth = 1;
        
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkGray
        label.shadowColor = UIColor.gray
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
