//
//  DataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/3/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class WenCaiQuery {
    //http://www.iwencai.com/stockpick/search?typed=0&preParams=&ts=1&f=1&qs=result_original&selfsectsn=&querytype=stock&searchfilter=&tid=stockpick&w=%E6%A6%82%E5%BF%B5%E6%9D%BF%E5%9D%97%E8%B5%84%E9%87%91+%E6%B6%A8%E8%B7%8C%E5%B9%85%E9%A1%BA%E5%BA%8F
    static var baseUrl = "http://www.iwencai.com/stockpick/search?ts=1&perpage=500&f=1&qs=stockhome_topbar_click&w=KEYWORDS"
    
    var token = ""
    
    static func getUrl(keywords:String) -> String {
        let theKeywords = keywords.replacingOccurrences(of: " ", with: "+")
        return WenCaiQuery.baseUrl.replacingOccurrences(of: "KEYWORDS", with: theKeywords)
    }
    
}



struct DataService {
    var date = ""
    var keywords = ""
    var title = ""
    var status:String?
    var handler:((String,String,Dictionary<String, Any>) -> Void)? = nil
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
        let service = DataService(date: Date().formatWencaiDateString(), keywords: keywords, title: keywords, status: "未获取") { (date, json, dict) in
            
        }
        
        dataServices.append(service)
    }
}

