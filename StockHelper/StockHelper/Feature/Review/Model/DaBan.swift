//
//  DaBan.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/6/30.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

enum DaBanQingXu: String {
    case QingXuXiuFu = "情绪修复"
    case ZhangTingChao = "涨停潮"
    case PuZhangFenQi = "普涨分歧"
    case YiZhiJiaSu = "一致加速"
    case FengXianYuJing = "风险预警"
    case ZhaBanChao = "炸板潮"
    case GuanXingKongHuang = "惯性恐慌"
    
    func description() -> String {
        switch self {
        case .QingXuXiuFu: return "反复无常的变化，是恐慌释放后的情绪修复的一个阶段。新股投机、逻辑操作、题材发酵、低位首板、龙头反抽等众多操作手法的共舞阶段。"
        case .ZhangTingChao: return "打板情绪"
        case .PuZhangFenQi: return "今日操作"
        case .YiZhiJiaSu: return "明日关注"
        case .FengXianYuJing: return "主流板块"
        case .ZhaBanChao: return ""
        case .GuanXingKongHuang: return ""
        }
    }
}
