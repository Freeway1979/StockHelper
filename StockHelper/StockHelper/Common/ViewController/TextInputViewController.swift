//
//  TextInputViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/13.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class TextInputViewController: UIViewController {
    public static func open(initText:String?, title:String, from navigator:UINavigationController) -> TextInputViewController {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TextInputViewController") as! TextInputViewController
        navigator.pushViewController(vc, animated: true)
        vc.title = title
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            if initText != nil {
                vc.textview.text = initText!
            }
        }
        return vc;
    }
    
    @IBOutlet weak var textview: UITextView!
    
    var onCompleted:((String) -> Void)? = nil
    
    var text: String? {
        get {
            textview.text ?? ""
        }
        set {
            textview.text = newValue ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews()  {
        
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        if self.onCompleted != nil {
            self.onCompleted!(self.text ?? "")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
