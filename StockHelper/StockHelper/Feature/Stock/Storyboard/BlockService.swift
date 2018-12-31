//
//  BlockService.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/31.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation
import Moya

enum BlockService {
    case getBlockList
    case getBlockStocks(code:String)
}

// MARK: - TargetType Protocol Implementation
extension BlockService: TargetType {
    var baseURL: URL { return URL(string: "https://raw.githubusercontent.com/Freeway1979/StockHelper/master/document")! }
    var path: String {
        switch self {
        case .getBlockList:
            return "/blocks.json"
        case .getBlockStocks(let code):
            return "/blocks/\(code).json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getBlockList,.getBlockStocks:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getBlockList,.getBlockStocks: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getBlockList:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .getBlockStocks( _):
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
