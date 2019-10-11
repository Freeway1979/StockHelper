//
//  StockHQ.swift
//  HelloWorldSwift
//
//  Created by andyli2 on 2019/2/22.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

enum StockHQType:String {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
}

struct StockHQList :Codable {
    var type:String = "Day"
    var code:String = ""
    var datas:[[String]] = []
    
    var hqList: [StockDayHQ] {
        var list:[StockDayHQ] = []
        let count = datas.count
        for index in 0...count-1 {
            let data = datas[index]
            let hq = StockDayHQ(data: data)
            hq.ma5 = calculateMA5(dataIndex: index)
            hq.ma10 = calculateMA10(dataIndex: index)
            hq.ma20 = calculateMA20(dataIndex: index)
            list.append(hq)
        }
        return list
    }
    
    func predictMA5(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 5)
    }
    func predictMA10(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 10)
    }
    func predictMA20(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 20)
    }
    
    func calculateMA5(dataIndex:Int) -> Float {
        return calculateMA(dataIndex: dataIndex)
    }
    
    func calculateMA10(dataIndex:Int) -> Float {
        return calculateMA(dataIndex: dataIndex,days: 10)
    }
    
    func calculateMA20(dataIndex:Int) -> Float {
        return calculateMA(dataIndex: dataIndex, days: 20)
    }
    
    func calculateMA(dataIndex:Int, days:Int = 5) -> Float {
        let count = datas.count
        if count <= dataIndex {
            return 0
        }
        var sum:Float = 0
        for index in dataIndex ..< dataIndex+days {
            if index < count {
                let data = datas[index]
                let date = data[StockDataIndex.Date.rawValue]
                let close = data[StockDataIndex.Close.rawValue].floatValue
                sum = sum + close
            } else {
                sum = 0 // Reset
            }
        }
        return sum / Float(days)
    }
    
    func predictedMA(predictedChange:Float, days:Int = 5) -> Float {
        let count = datas.count
        if count <= 0 {
            return 0
        }
        var sum:Float = 0
        let lastClose:Float = datas[count-1][StockDataIndex.Close.rawValue].floatValue
        for (index, data) in datas.enumerated().reversed()  {
            if (index+days-1) >= count {
                sum = sum + data[StockDataIndex.Close.rawValue].floatValue
            }
            else {
                break
            }
        }
        sum = sum + lastClose * (1+predictedChange/100)
        return sum / Float(days)
    }
    
    func zhangDieTingPrice() -> (Float,Float) {
        let count = datas.count
        if count <= 0 {
            return (0,0)
        }
        let lastClose:Float = datas[count-1][StockDataIndex.Close.rawValue].floatValue
        let zt = (lastClose * 1.1).roundedDot2Float
        let dt = (lastClose * 0.9).roundedDot2Float
        return (Float(zt),Float(dt))
    }
}

enum StockDataIndex:Int {
    case Date = 0
    case Open = 1
    case High = 2
    case Low = 3
    case Close = 4
    case PriceChange = 5
    case PriceChangePercentage = 6
    case Transactions = 7
    case TransactionsMoneny = 8
}

class StockDayHQ {
    //Stored
    var data:[String] = []
    var ma5:Float = 0
    var ma10:Float = 0
    var ma20:Float = 0
    
    required init(data:[String]) {
        self.data = data
    }
    //Computed
    var isDuoTou: Bool {
        return ma5 > ma10 && ma10 > ma20
    }
    var isKouTou: Bool {
        return ma5 < ma10 && ma10 < ma20
    }
    var isAboveMA5:Bool {
        return close > ma5
    }
    var isBelowMA5:Bool {
        return close < ma5
    }
    var isAboveMA10:Bool {
        return close > ma10
    }
    var isBelowMA10:Bool {
        return close < ma10
    }
    var isAboveMA20:Bool {
        return close > ma20
    }
    var isBelowMA20:Bool {
        return close < ma20
    }
    //上影线
    var isShangYingXian:Bool {
        let max:Float = [open, close].max()!
        return (high * 1000 / max) > 5
    }
    //下影线
    var isXiaYingXian:Bool {
        let min:Float = [open, close].min()!
        return (min * 1000 / low) > 5
    }
    //长上影线
    var isChangShangYingXian:Bool {
        let max:Float = [open, close].max()!
        return (high * 1000 / max) > 20
    }
    //长下影线
    var isChangXiaYingXian:Bool {
        let min:Float = [open, close].min()!
        return (min * 1000 / low) > 15
    }
    
    var date: String {
        return data[StockDataIndex.Date.rawValue]
    }
    var open: Float {
        return data[StockDataIndex.Open.rawValue].floatValue
    }
    var high: Float {
        return data[StockDataIndex.High.rawValue].floatValue
    }
    var low: Float {
        return data[StockDataIndex.Low.rawValue].floatValue
    }
    var close: Float {
        return data[StockDataIndex.Close.rawValue].floatValue
    }
    var priceChange: Float {
        return data[StockDataIndex.PriceChange.rawValue].floatValue
    }
    var priceChangePercentage: String {
        return data[StockDataIndex.PriceChangePercentage.rawValue]
    }
    var transactions: String {
        return data[StockDataIndex.Transactions.rawValue]
    }
    var transactionsMoney: String {
        return data[StockDataIndex.TransactionsMoneny.rawValue]
    }
}

extension Float {
    var formatDot2String: String {
        return String(format: "%.2f", self)
    }
}

 extension String {
    var floatValue: Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: self)
        let numberFloatValue = number?.floatValue
        return numberFloatValue ?? 0
    }
}
