//
//  Message.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

struct Message {
    private var subject:String = "";
    private var source:String = "";
    private var category:String = "";
    private var time:Date;
    private var positiveMemo:String = "";
    private var negativeMemo:String = "";
    private var positiveBlocks:[StockBlock];
    private var negativeBlocks:[StockBlock];
}
