//
//  DaBan.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/6/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

enum ChaoDuanQingXu: String {
    case QingXuXiuFu = "情绪修复"
    case PuZhangQiDong = "普涨启动"
    case HangQingFenHua = "行情分化"
    case YiZhiJiaSu = "一致加速"
    case GaoWeiFenQi = "高位分歧"
    case ZhaBanChao = "炸板潮"
    case GuanXingKongHuang = "惯性恐慌"
    case FengXianShiFang = "风险释放"
    
    static let allValues = [QingXuXiuFu,PuZhangQiDong, HangQingFenHua,YiZhiJiaSu,GaoWeiFenQi,ZhaBanChao,GuanXingKongHuang,FengXianShiFang]
}
