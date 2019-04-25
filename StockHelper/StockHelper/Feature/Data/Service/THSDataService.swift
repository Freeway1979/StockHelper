//
//  DataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/20.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

import Moya

enum DataService {
    case getStockList //Only stocks
}

// MARK: - TargetType Protocol Implementation
extension DataService: TargetType {
    var baseURL: URL { return URL(string: ServiceConfig.baseUrl)! }
    var path: String {
        switch self {
        case .getJiejinStocks:
            return "/blocks.json"
        
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
        case .getStockList,.getBlockList,
             .getSimpleBlock2Stocks,
             .getYanBaoShe,
             .getXuangu,
             .getSimpleStock2Blocks:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json,application/text"]
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
