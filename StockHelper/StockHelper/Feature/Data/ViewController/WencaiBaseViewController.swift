//
//  WencaiBaseViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/7/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

//
//  DataBuildViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/3/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup

class WencaiBaseViewController: UIViewController {
    var token:String?
    var dataService: DataService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareWebView(webview:WKWebView) {
        webview.navigationDelegate = self;
        webview.evaluateJavaScript("navigator.userAgent") { (data, error) in
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            webview.customUserAgent = userAgent
        }
    }
    
    func loadWencaiQueryPage(webview:WKWebView,dataService: DataService) {
        prepareWebView(webview: webview)
        self.dataService = dataService
        let url = WenCaiQuery.getUrl(keywords:dataService.keywords)
        loadWebPage(with: url, webview: webview)
    }
    
    //    http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    
    
    func loadWebPage(with url:String,webview:WKWebView) {
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(encodedUrl)
        webview.load(URLRequest(url: URL(string: encodedUrl)!))
    }
}

extension WencaiBaseViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //        //   修改界面元素的值
        //        let findInputScript = "document.getElementsByTagName('textarea')[0].value='二级行业板块';";
        //        webView.evaluateJavaScript(findInputScript) { (data, error) in
        //            let rs = data as! String
        //            print(rs)
        //            let findSearchSubmitScript = "document.getElementsByTagName('form')[0].submit();"
        //            webView.evaluateJavaScript(findSearchSubmitScript) { (data, error) in
        //                let rs = data as! String
        //                print(rs)
        //            }
        //        }
        
        webView.evaluateJavaScript("document.body.innerHTML") { [unowned self] (data, error) in
            
            let rs = data as! String
            
            if (rs.contains("token")) {
                print("token found")
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
            } else {
                print("token not found")
            }
            
            WencaiUtils.parseHTML(html: rs, callback: { (jsonString, dict) in
                print(dict)
                if ((self.dataService?.handler) != nil) {
                    self.dataService?.handler!("", jsonString,dict)
                }
            })
        }
    }
}


