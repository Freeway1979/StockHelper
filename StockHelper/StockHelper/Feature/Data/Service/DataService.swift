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
    
    static var paginationUrl = "http://www.iwencai.com/stockpick/cache?token=THE_TOKEN&p=1&perpage=THE_PERPAGE&changeperpage=THE_PAGE"
    
    var token = ""
    
    static func getPaginationUrl(token:String,perpage:Int = 100, page:Int = 1, extra: String? = nil) -> String {
        var url = WenCaiQuery.paginationUrl.replacingOccurrences(of: "THE_TOKEN", with: token)
        url = url.replacingOccurrences(of: "THE_PERPAGE", with: String(perpage))
        url = url.replacingOccurrences(of: "THE_PAGE", with: String(page))
        if extra != nil {
            url = "\(url)&\(extra!)"
        }
        return url
    }
    
    static func getUrl(keywords:String) -> String {
        let theKeywords = keywords.replacingOccurrences(of: " ", with: "+")
        return WenCaiQuery.baseUrl.replacingOccurrences(of: "KEYWORDS", with: theKeywords)
    }
}



class DataService {
    var date = ""
    var keywords = ""
    var title = ""
    var status:String?
    var paginationService:DataService?
    var perpage: Int = 1000
    var handler:((String,String,Dictionary<String, Any>) -> Void)? = nil
    var onComplete:(([Any]?) -> Void)? = nil
    var onStart:(() -> Void)? = nil
    init(date:String,keywords:String,title:String) {
        self.date = date
        self.keywords = keywords
        self.title = title
    }
    
    func handleResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        
    }
}


