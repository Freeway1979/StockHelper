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

class DataBuildViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
    var token:String?
    var dataServices: [DataService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.prepareData()
        self.tableView.reloadData()
        
        self.webView.evaluateJavaScript("navigator.userAgent") { (data, error) in
//            print(data,error)
            let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
            self.webView.customUserAgent = userAgent
        }
    }
    
    @IBAction func onMenuButtonClicked(_ sender: UIBarButtonItem) {
         toggleSideMenuView()
    }
    
//    http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    
    
    @IBAction func onBuildClicked(_ sender: UIButton) {
        let url = WenCaiQuery.getUrl(keywords: dataServices[0].keywords)
        loadWebPage(with: url)
    }
    
    func loadWebPage(with url:String) {
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(encodedUrl)
        self.webView.load(URLRequest(url: URL(string: encodedUrl)!))
    }
    
    func prepareData() {
        //var services = self.dataServices
        let service = DataService(keywords: "概念板块资金 涨跌幅顺序 成交额大于100亿", title: "概念板块资金", status: "ddd")  { (json, dict) in
            
        }
        dataServices.append(service)
    }
}

extension DataBuildViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataServices[indexPath.row]
        let view = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        view.detailTextLabel?.text = item.status
        view.textLabel?.text = item.title
        return view
    }
    
    
}
extension DataBuildViewController:UITableViewDelegate {

    
}
extension DataBuildViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(navigation)
        
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
        
        self.webView.evaluateJavaScript("document.body.innerHTML") { (data, error) in
            
            let rs = data as! String
            
            if (rs.contains("token")) {
                print("token found")
               self.token = WencaiUtils.parseTokenFromHTML(html: rs)
            } else {
                print("token not found")
            }
        
            WencaiUtils.parseHTML(html: rs, callback: { (data, dict) in
//                var obj = WenCaiBlockTops(blocks: [], query: "", date: "")
//                obj.fillDataFromDictionary(dict: dict)
////                DataCache.blockTops = obj
//                print(obj)
            })
        }
    }
}

extension DataBuildViewController: ENSideMenuDelegate {
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
}
