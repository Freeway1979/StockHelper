//
//  WencaiUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/7/15.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import WebKit

class WencaiUtils {
    class func prepareWebView(webview:WKWebView) {
        webview.evaluateJavaScript("navigator.userAgent") { (data, error) in
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            webview.customUserAgent = userAgent
        }
    }
    
   class func loadWencaiQueryPage(webview:WKWebView,dataService: DataService) {
        let url = WenCaiQuery.getUrl(keywords:dataService.keywords)
        self.loadWebPage(with: url, webview: webview)
    }
    
    //    http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    
   class func loadWebPage(with url:String,webview:WKWebView) {
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(encodedUrl)
        webview.load(URLRequest(url: URL(string: encodedUrl)!))
    }
    
    class func parseTokenFromHTML(html:String) -> String {
        let pattern = "\"token\":\"(\\w+)\""
        let regex = try! NSRegularExpression(pattern: pattern, options:[])
        let matches = regex.matches(in: html, options: [], range: NSRange(html.startIndex...,in: html))
        let match = matches.first
        let rs = (String(html[Range((match?.range(at: 1))!, in: html)!]))
        print(rs)
        return rs
    }
    
   class func parseHTML(html:String, callback:@escaping (String,Dictionary<String, Any>) -> Void) {
        let pattern = "var allResult = \\{(.*)\\}\\;"
        let regex = try! NSRegularExpression(pattern: pattern, options:[])
        let matches = regex.matches(in: html, options: [], range: NSRange(html.startIndex...,in: html))
        let match = matches.first
        if (match != nil) {
            let rs = (String(html[Range((match?.range(at: 1))!, in: html)!]))
            let jsonString = "{\(rs)}"
            let cfEnc = CFStringEncodings.GB_18030_2000
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            let dict = jsonString.toDictionary(encoding: String.Encoding(rawValue: enc))
            callback(jsonString, dict as! Dictionary<String, Any>)
        }
    }
}
