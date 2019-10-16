//
//  TextInputViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/13.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class TextInputViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    
    var placeHolder: String {
        get {
            textfield.placeholder ?? ""
        }
        set {
            textfield.placeholder = newValue
        }
    }
    
    var text: String {
        get {
            textfield.text ?? ""
        }
        set {
            textfield.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews()  {
        textfield.adjustsFontSizeToFitWidth = true
        textfield.minimumFontSize = 12
        textfield.becomeFirstResponder()
    }
}


extension TextInputViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //TODO:
        return true;
    }
}
