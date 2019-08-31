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
    
    class func loadWencaiPaginationData(webview:WKWebView,token:String,perpage:Int, page:Int, extra: String) {
        let url = WenCaiQuery.getPaginationUrl(token: token,perpage: perpage,page: page, extra:extra)
        print(url)
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
        return rs
    }
    
    // "result":[["601398.SH","\u5de5\u5546\u94f6\u884c","5.42","0.744",1461298191961.3999,"1\/3689","MSCI\u6982\u5ff5;\u592e\u89c6\u8d22\u7ecf50;\u878d\u8d44\u878d\u5238;\u6caa\u80a1\u901a;\u8f6c\u878d\u5238\u6807\u7684;\u4f18\u5148\u80a1\u6982\u5ff5;\u5bcc\u65f6\u7f57\u7d20\u6982\u5ff5\u80a1;\u5916\u6c47\u5c40\u6301\u80a1",8,1842811248546.2,"\u91d1\u878d\u670d\u52a1-\u94f6\u884c-\u94f6\u884c\u2162",4688]],
    class func parseResultDataFromHTML(html:String) -> (Dictionary<String, Any>?, String) {
        guard let range = html.range(of: "result\":[[") else {
            return (nil,"")
        }
        let left = html.suffix(from:range.upperBound)
        guard let range2 = left.range(of: "]]") else {
            return (nil,"")
        }
        let pattern = "<a href.*</a>,"
        let regex = try! Regex(pattern)
        let rs = String(left.prefix(upTo: range2.lowerBound))
        let rs2 = regex.replacingMatches(in: rs, with: "")

        let jsonString = "{\"result\":[[\(rs2)]]}"
        
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let dict = jsonString.toDictionary(encoding: String.Encoding(rawValue: enc))
        return (dict as? Dictionary<String, Any>, jsonString)
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
    
    class func parseRawJSON(jsonString:String, callback:@escaping (Dictionary<String, Any>) -> Void) {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let dict = jsonString.toDictionary(encoding: String.Encoding(rawValue: enc))
        
        callback(dict as! Dictionary<String, Any>)
    }
}
