//
//  TextViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/1.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var resultTextView: UITextView!
    private var selectedText: NSAttributedString?
    private var text:String?
    private var url:String?
    public static func open(url _url:String,title _title:String, from viewController:UIViewController) {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TextViewController") as! TextViewController
        vc.title = _title
        let url = _url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        vc.url = url;
       
        viewController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.delegate = self
      
        // Do any additional setup after loading the view.
        loadTextFromWeb()
    }
    
    func loadTextFromWeb()  {
        do {
            let uri = URL(string: url!)
            let data = try Data(contentsOf: uri!)
            if (data.count) > 0 {
                let str = String(data: data, encoding: String.Encoding.utf8)
                text = str
                contentTextView.text = str
            }
        } catch {
            print(error)
        }
        
    }


}
extension TextViewController:UISearchBarDelegate {
    
    // MARK:UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.count > 0 {
//            selectedText = NSAttributedString(string: searchText, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20.5),NSAttributedString.Key.backgroundColor:UIColor.red])
//          self.contentTextView.attributedText = selectedText
            
            let range = text?.range(of: searchText)
            if range != nil {
                let indexStart = text!.index((range?.lowerBound)!, offsetBy: 0)
                let indexEnd = text!.index((range?.upperBound)!, offsetBy: 50)
                let ss = text![indexStart..<indexEnd]
                //找到某一行
                resultTextView.text = String(ss);
            } else {
                resultTextView.text = ""
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

