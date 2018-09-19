//
//  StockBlock.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

enum BlockType {
    case Concept
    case Location
    case Style
}
struct StockBlock
{
    private var code:String = "";
    private var name:String = "";
    private var type:BlockType = .Concept ;
    private var gainOfRiseFall:Float = 0.0;
}
