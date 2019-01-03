//
//  MessageServiceProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/3.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import Moya

class MessageServiceProvider {
    private static var messages:[Message] = []
    
    
    public static func getMessageList(callback:@escaping ([Message]) -> Void ) {
        if MessageServiceProvider.messages.count > 0 {
            callback(MessageServiceProvider.messages)
            return
        }
        let provider = MoyaProvider<MessageService>()
        provider.request(MessageService.getMessageList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
//                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
//                    print(dict!);
                    let decoder = JSONDecoder()
                    let messages = try! decoder.decode([Message].self, from: jsonData)
                    MessageServiceProvider.messages = messages
                    callback(messages)
                }
            }
        }
    }
}

