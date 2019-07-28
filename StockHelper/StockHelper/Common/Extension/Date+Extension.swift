//
//  Date+Extension.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/7/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension Date {
    func format(_ dateFormat: String, LocalId: String = "zh_CN") -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: LocalId)
        df.dateFormat = dateFormat
        let str = df.string(from: self)
        return str
    }
    var isWorkingDay: Bool {
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
        if (weekday! >= 1 && weekday! <= 5) {
            return true
        }
        
        return false
    }
}
