//
//  THSDataProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/20.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import Moya
import SwiftSoup

class THSDataProvider {
    
    public static func getJieJinStockList(callback:@escaping ([JieJinStock]) -> Void) {
        
        
        let provider = MoyaProvider<THSDataService>()
        provider.request(THSDataService.getJiejinStocks(page: 1)) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                var stocks:[JieJinStock] = []
                let responseText = try? response.mapString()
                if responseText != nil {
                    stocks = parseJieJinStocks(html: responseText!)
                }
                callback(stocks)
            }
        }
    }
    
    private static func parseJieJinStocks(html:String) -> [JieJinStock] {
        var stocks:[JieJinStock] = []
        do {
            let html = "<html><head><title>First parse</title></head>"
                + "<body><p>Parsed HTML into a doc.</p></body></html>"
            let doc: Document = try SwiftSoup.parse(html)
            print(try doc.text())
//
//            let text: String = try doc.body()!.text(); // "An example link"
//            let linkHref: String = try link.attr("href"); // "http://example.com/"
//            let linkText: String = try link.text(); // "example""
//
//            let linkOuterH: String = try link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
//            let linkInnerH: String = try link.html(); // "<b>example</b>"
        } catch Exception.Error(let type, let message) {
            print(type,message)
        } catch {
            print("error")
        }
        return stocks
    }
}
