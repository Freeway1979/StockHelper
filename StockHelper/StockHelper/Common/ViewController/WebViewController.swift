//
//  WebViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import ZKProgressHUD

class WebViewController: UIViewController {

    private var url:String?
    public static func open(website url:String,withtitle title:String, from viewController:UIViewController) {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = url
        vc.title = title
        viewController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        url = url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if url != nil {
            let urlRequest:URLRequest = URLRequest(url: URL(string: url!)!)
            webView.load(urlRequest)
        }
       
        // Do any additional setup after loading the view.
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

extension WebViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZKProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       ZKProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZKProgressHUD.dismiss()
    }
}
