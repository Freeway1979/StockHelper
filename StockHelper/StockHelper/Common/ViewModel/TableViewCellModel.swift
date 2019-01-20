//
//  TableViewCellModel.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/20.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit

struct TableViewCellModel {
    var id:String?
    var title:String = ""
    var detail:String = ""
    var cellStyle:UITableViewCell.CellStyle = .default
    var accessoryType:UITableViewCell.AccessoryType = .none
}
