//
//  MessageDetailViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var message:Message?
    
    var subject:String {
        get {
            if (self.subjectLabel.text != nil) {
                return self.subjectLabel.text!
            }
            return "无主题"
        }
        set {
            self.subjectLabel.text! = newValue
        }
    }
    
    private var body:String {
        get {
            if (self.bodyLabel.text != nil) {
                return self.bodyLabel.text!
            }
            return "无内容"
        }
        set {
            self.bodyLabel.text! = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews();
    }
    
    private func setupViews() {
        self.bodyLabel.adjustsFontSizeToFitWidth = true
        self.subject = self.message!.displayTitle;
        self.body = self.message!.displayStocks.replacingOccurrences(of: " ", with: "\n\n")
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
