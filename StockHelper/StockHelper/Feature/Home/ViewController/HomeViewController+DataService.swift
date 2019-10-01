//
//  HomeViewController+DataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/28.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension HomeViewController {
    func isAllCompleted() -> Bool {
        return serviceIndex == dataServices.count - 1
    }
    
    func removeServices() {
        serviceIndex = 0
        self.dataServices.removeAll()
        self.dataService = nil
    }
    
    func getFirstService() -> DataService? {
        return self.dataServices.first
    }
    
    func getNextService() -> DataService? {
        serviceIndex = serviceIndex + 1
        if serviceIndex < dataServices.count {
            return dataServices[serviceIndex]
        }
        return nil
    }
    
    func currentService() -> DataService? {
        return nil
    }

    func addService(dataService:DataService) {
        self.dataServices.append(dataService)
        if dataService.paginationService != nil {
            self.addService(dataService: dataService.paginationService!)
        }
    }
    
    func addAndRunService(webView:WKWebView, dataService:DataService) {
        self.addService(dataService: dataService)
        self.runService(webView: webView, dataService: dataService)
    }
    
    func runNextService(webView:WKWebView) {
        guard let dataService = self.getNextService() else { return }
        self.runService(webView: webView, dataService: dataService)
    }
    
    func runService(webView:WKWebView, dataService:DataService) {
        self.dataService = dataService
        WencaiUtils.loadWencaiQueryPage(webview: webView, dataService: dataService)
    }
    
    func setupWebView(webView:WKWebView) {
        webView.navigationDelegate = self;
        webView.evaluateJavaScript("navigator.userAgent") { (data, error) in
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            webView.customUserAgent = userAgent
        }
    }
    
    func onDataLoaded() {
       print("onDataLoaded")
       self.removeServices()
    }
    
    func goNext(webView:WKWebView) {
        if (self.isAllCompleted()) {
            self.onDataLoaded()
        } else {
            guard let dataService = self.getNextService() else {
                return
            }
            self.dataService = dataService
            if (dataService.keywords == "cacheToken") {
                let extra = "showType=[\"\",\"\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\",\"onTable\"]"
                let perpage:Int = dataService.perpage
                WencaiUtils.loadWencaiPaginationData(webview: webView, token: self.token!, perpage: perpage, page: 1, extra: extra)
            } else {
                
                WencaiUtils.loadWencaiQueryPage(webview: webView, dataService: dataService)
            }
        }
    }
    
    private func handleRawResponse(webView:WKWebView, json:String,dict:Dictionary<String, Any>?) {
        if (dict != nil) {
            guard let dataService = self.dataService else {
                return
            }
            if dataService.handler != nil {
                dataService.handler!(dataService.date, json, dict!)
            } else {
                dataService.handleResponse(date: dataService.date, json: json, dict: dict!)
            }
            self.goNext(webView: webView)
        }
    }
    
    func handleNorthMoneyData(html:String) -> [String] {
        let lines = html.components(separatedBy: "\n")
        var start:Bool = false
        var validLines:[String] = []
        var count = 0
        for index in 0 ..< lines.count {
            let line = (lines[index])
            if line.contains("id=\"north_zjl\"") {
                start = true
            }
            if start {
                if count < 3 && line.contains("当日净流入") {
                    validLines.append(line)
                    count = count + 1
                }
            }
            if count >= 3 {
                break
            }
        }
        var result:[String] = []
        validLines.forEach { (line) in
            print(line)
            var pattern = ">([\\-0-9\\.万亿]+)元</span></span></span><span>当日余额(.*)>([\\-0-9\\.万亿]+)亿元</span></span></span></li>"
            var regex = try? NSRegularExpression(pattern: pattern, options:[])
            var matches = regex!.matches(in: line, options: [], range: NSRange(line.startIndex...,in: line))
            if matches.count > 0 {
                let match = matches.first
                let rs = (String(line[Range((match?.range(at: 1))!, in: line)!]))
                result.append(rs)
            } else {
                pattern = ">([\\-0-9\\.万亿]+)元</span></span></span></li>"
                regex = try? NSRegularExpression(pattern: pattern, options:[])
                matches = regex!.matches(in: line, options: [], range: NSRange(line.startIndex...,in: line))
                if matches.count > 0 {
                    let match = matches.first
                    let rs = (String(line[Range((match?.range(at: 1))!, in: line)!]))
                    result.append(rs)
                }
            }
        }
        return result
    }
}

extension HomeViewController: WKNavigationDelegate {
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
            if (webView.url?.absoluteString == WebSite.NorthMoney) {
                let northMoney = self.handleNorthMoneyData(html: rs)
                self.onNorthMoneyHandled(northMoney: northMoney)
                return
            }
            if (rs.contains("\"token\":")) {
                self.token = WencaiUtils.parseTokenFromHTML(html: rs)
                WencaiUtils.parseHTML(html: rs, callback: { [unowned self] (jsonString, dict) in
                    self.handleRawResponse(webView: webView, json: jsonString, dict: dict)
                })
            } else {
                let (dict, json) = WencaiUtils.parseResultDataFromHTML(html: rs)
                self.handleRawResponse(webView: webView, json: json, dict: dict)
            }
        }
    }
}



