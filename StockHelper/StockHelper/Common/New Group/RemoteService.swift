//
//  RemoteService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/1.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import Moya

enum RemoteService {
    case getRemoteAddress
}
extension RemoteService: TargetType {
    var baseURL: URL { return URL(string: ServiceConfig.baseUrl)! }
    var path: String {
        switch self {
        case .getRemoteAddress:
            return "/serverconfig.json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getRemoteAddress:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getRemoteAddress: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getRemoteAddress:
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

class RemoteServiceProvider {
    
    public static var remoteServerAddress:String = "8.8.8.8";
    
    public static func getRemoteServerIPAddress(callback:@escaping (_ address:String) -> Void ) {
        let provider = MoyaProvider<RemoteService>()
        provider.request(RemoteService.getRemoteAddress) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary<String, String>
                    print(dict!);
                    RemoteServiceProvider.remoteServerAddress = dict!["ip"]!
                    callback(dict!["ip"]!)
                }
            }
        }
    }
}
