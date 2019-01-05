//
//  StockService.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/31.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation
import Moya

enum StockService {
    case getStockList //Only stocks
    case getBlockList //Only blocks
    case getSimpleBlock2Stocks //Blocks and Stocks Code Only
    case getSimpleStock2Blocks //
}

// MARK: - TargetType Protocol Implementation
extension StockService: TargetType {
    var baseURL: URL { return URL(string: ServiceConfig.baseUrl)! }
    var path: String {
        switch self {
        case .getBlockList:
            return "/blocks.json"
        case .getStockList:
            return "/stocks.json"
        case .getSimpleBlock2Stocks:
            return "/block2stocks.dat"
        case .getSimpleStock2Blocks:
            return "/stock2blocks.dat"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getStockList,.getBlockList,
             .getSimpleBlock2Stocks,.getSimpleStock2Blocks:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getStockList,.getBlockList,
             .getSimpleBlock2Stocks,.getSimpleStock2Blocks: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getStockList,.getBlockList,
             .getSimpleBlock2Stocks,.getSimpleStock2Blocks:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
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
