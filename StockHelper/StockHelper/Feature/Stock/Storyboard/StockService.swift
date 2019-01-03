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
    case getSimpleBlocks //Blocks and Stocks Code Only
    case getBlockStocksDetail(code:String) //Get block and stocks by block code
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
        case .getSimpleBlocks:
            return "/simpleblocks.dat"
        case .getBlockStocksDetail(let code):
            return "/blocks/\(code).json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getStockList,.getBlockList,.getSimpleBlocks,.getBlockStocksDetail:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getStockList,.getBlockList,.getSimpleBlocks,.getBlockStocksDetail: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getStockList,.getBlockList,.getSimpleBlocks:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .getBlockStocksDetail( _):
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
