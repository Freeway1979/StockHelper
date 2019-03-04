//
//  StockHQ.swift
//  HelloWorldSwift
//
//  Created by andyli2 on 2019/2/22.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct StockHQList :Codable {
    var type:String = "Day"
    var code:String = ""
    var datas:[[String]] = []
    
    func predictMA5(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 5)
    }
    func predictMA10(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 10)
    }
    func predictMA20(predictedChange:Float) -> Float {
        return self.predictedMA(predictedChange: predictedChange, days: 20)
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
                print("\(index), \(data)")
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
    case TransactionsPercentage = 9
    
}
struct StockDayHQ {
    
    //Stored
    var data:[String] = []
    
    //Computed
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
    var transactionsPercentage: Float {
        return data[StockDataIndex.TransactionsPercentage.rawValue].floatValue
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
