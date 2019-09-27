//
//  WebSite.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/23.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

struct WebSite {
    public static let WenCai = "https://www.iwencai.com/"
    // 股票行情网页版
    public static let StockPage = "http://m.10jqka.com.cn/stockpage/hs_STOCKCODE/#&atab=geguNews"
    
    public static let DapanPage = "http://m.10jqka.com.cn/stockpage/DAPAN/#&atab=geguNews"
    
    public static let Dapan_SH = "16_1A0001"
    public static let Dapan_SZ = "32_399001"
    public static let Dapan_CYB = "32_399006"
    
    public static func getDapanPageUrl(code:String) -> String {
        return DapanPage.replacingOccurrences(of: "DAPAN", with: code)
    }
    
    public static func getStockPageUrl(code:String) -> String {
        return StockPage.replacingOccurrences(of: "STOCKCODE", with: code)
    }
}
