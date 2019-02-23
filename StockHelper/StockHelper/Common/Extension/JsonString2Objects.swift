//
//  JsonString2Objects.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/17.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension String {
    func json2Objects<T:Decodable>() -> [T] {
        let jsonData:Data = self.data(using: .utf8)!
        let decoder = JSONDecoder()
        let objects = try! decoder.decode([T].self, from: jsonData)
        return objects;
    }
}
