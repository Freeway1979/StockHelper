//
//  DataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/3/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class WenCaiQuery {
    static var baseUrl = "http://www.iwencai.com/stockpick/search?ts=1&f=1&qs=stockhome_topbar_click&w=KEYWORDS"
    
    var token = ""
    
    static func getUrl(keywords:String) -> String {
        let theKeywords = keywords.replacingOccurrences(of: " ", with: "+")
        return WenCaiQuery.baseUrl.replacingOccurrences(of: "KEYWORDS", with: theKeywords)
    }
    
}



struct DataService {
    var keywords = ""
    var title = ""
    var status:String?
    var handler:((_ data:String) -> String)? = nil
}

enum WenCaiKeywords:String {
    case BankuaiHY = "二级行业板块"
    case BankuaiMoney = "概念板块资金 涨跌幅顺序"
    case BankuaiZhangTing = "概念板块 涨停数排序"
}

class DataManager {
    
    private static var dataServices:[DataService] = []
    
    public static func prepareData() {
        dataServices.removeAll()
        let keywords = WenCaiKeywords.BankuaiHY.rawValue
        let service = DataService(keywords: keywords, title: keywords, status: "未获取") { (data) -> String in
            return data;
        }
        dataServices.append(service)
    }
}

