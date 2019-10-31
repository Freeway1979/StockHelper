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
    public static let ZhangDieTing = "http://stock.jrj.com.cn/tzzs/zdtwdj.shtml"
    public static let JieJin = "http://data.10jqka.com.cn/market/xsjj/"
    public static let NewStock = "http://data.10jqka.com.cn/ipo/xgsgyzq/"
    //北向资金
    public static let NorthMoney = "http://data.eastmoney.com/hsgt/index.html"
    //大盘历史行情
    public static let DapanHistory = "http://q.stock.sohu.com/hisHq?code=zs_000001&stat=1&order=D&period=d&callback=historySearchHandler&rt=jsonp&TIME"
    // 股票行情网页版
    public static let StockPage = "http://m.10jqka.com.cn/stockpage/hs_STOCKCODE/#&atab=geguNews"
    public static let StockDiagnosticPage = "http://www.iwencai.com/stockpick/search?tid=stockpick&qs=stockpick_diag&ts=1&w=STOCKCODE"
    
    public static let DapanPage = "http://m.10jqka.com.cn/stockpage/DAPAN/#&atab=geguNews"
    
    public static let Dapan_SH = "16_1A0001"
    public static let Dapan_SZ = "32_399001"
    public static let Dapan_CYB = "32_399006"
    
    public static func getDapanPageUrl(code:String) -> String {
        return DapanPage.replacingOccurrences(of: "DAPAN", with: code)
    }
    
    public static func getStockDiagnosticPageUrl(code:String) -> String {
        return StockDiagnosticPage.replacingOccurrences(of: "STOCKCODE", with: code)
    }
    
    public static func getStockPageUrl(code:String) -> String {
        return StockPage.replacingOccurrences(of: "STOCKCODE", with: code)
    }
}
