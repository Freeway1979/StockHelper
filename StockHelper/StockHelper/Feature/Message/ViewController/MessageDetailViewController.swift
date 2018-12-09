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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews();
    }
    
    private func setupViews() {
        self.subject = (self.message?.subject)!;
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
