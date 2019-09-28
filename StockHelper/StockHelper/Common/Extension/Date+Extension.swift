//
//  Date+Extension.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/7/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension Date {
    func format(_ dateFormat: String = "yyyy.MM.dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        dateFormatter.locale =  Locale.init(identifier: "zh_CN")
        return dateFormatter.string(from: self)
    }
    
    func formatSimpleDate() -> String {
        self.format("yyyyMMdd")
    }
    
    func formatWencaiDateString() -> String {
        return self.format()
    }
    
    var isWorkingDay: Bool {
        let weekday = self.weekDay
        if (weekday >= 1 && weekday <= 5) {
            return true
        }
        return false
    }
    
    var weekDay: Int {
        var calendar = Calendar.current
        //Sunday: 1
        //Monday: 2
        //Tuesday: 3
        //Wednesday: 4
        //Thurday: 5
        //Friday: 6
        //Saturday: 7
        //calendar.firstWeekday = 1
        calendar.timeZone = TimeZone.init(identifier: "Asia/Shanghai")!;
        calendar.locale = Locale.init(identifier: "zh_CN")
        var weekday = calendar.dateComponents([.weekday], from: self).weekday
        weekday = (weekday! - 1) % 7
        return weekday!
    }
    
    var hours:Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.init(identifier: "Asia/Shanghai")!;
        calendar.locale = Locale.init(identifier: "zh_CN")
        return calendar.dateComponents([.hour], from: self).hour ?? 0
    }
    
    var isMarketClosed:Bool {
        return self.hours > 15 || self.hours < 9
    }
}
