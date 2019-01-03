//
//  MessageService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/3.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import Moya

enum MessageService {
    case getMessageList
}

// MARK: - TargetType Protocol Implementation
extension MessageService: TargetType {
    var baseURL: URL { return URL(string: ServiceConfig.baseUrl)! }
    var path: String {
        switch self {
        case .getMessageList:
            return "/message.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getMessageList:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getMessageList: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getMessageList:
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

