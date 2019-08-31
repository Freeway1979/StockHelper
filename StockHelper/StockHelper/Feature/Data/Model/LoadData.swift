//
//  LoadData.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/8/31.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class LoadData:Codable {
    var title:String = ""
    var status:Bool  = false
    var count: Int = 0
    var updateTime:Date?
    
    init(title:String, status: Bool, count: Int, updateTime: Date?) {
        self.title = title
        self.status = status
        self.count = count
        self.updateTime = updateTime
    }
    
    var description:String {
        return "\(title) \(count) \(status)"
    }
    
    public static func loadData() -> [LoadData] {
        let rs:[LoadData] = StockUtils.loadData(key: "loadDataList")
        return rs
    }
    public static func saveData(loadDataList:[LoadData]) {
        StockUtils.saveData(data: loadDataList, key: "loadDataList")
    }
}


