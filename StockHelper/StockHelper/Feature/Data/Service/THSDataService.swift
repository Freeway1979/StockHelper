//
//  DataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/20.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

import Moya

enum THSDataService {
    case getJiejinStocks(page:Int) //解禁股列表
}

// MARK: - TargetType Protocol Implementation
extension THSDataService: TargetType {
    var baseURL: URL { return URL(string: ServiceConfig.THS)! }
    var path: String {
        switch self {
        case .getJiejinStocks(let page):
            return "/market/xsjj/field/enddate/order/asc/page/\(page)/ajax/1/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJiejinStocks:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getJiejinStocks: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getJiejinStocks:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
                "Accept-Encoding": "gzip, deflate",
                "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
                "Cache-Control": "max-age=0",
                "Connection": "keep-alive",
                "Host": "data.10jqka.com.cn",
                "Upgrade-Insecure-Requests": "1",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"
        ]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
