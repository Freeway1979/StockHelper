//
//  StockTagViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

class StockTagViewController: TableCRUDViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    var stock:Stock?
    override func buildTableData() -> [TableViewSectionModel] {
        let extra:StockExtra? = DataCache.getStockExtra(code: stock!.code)
        var rs:[TableViewSectionModel] = []
        var sec = TableViewSectionModel(id: stock?.code, title: stock!.name, rows: [], data: stock?.code)
        if extra != nil {
            let rows = extra?.tagList.map({ (tag) -> TableViewCellModel in
                TableViewCellModel(id: tag, title: tag, detail: tag, cellStyle: .default, accessoryType: .none, data: tag)
            })
            sec.rows = rows ?? []
        }
        rs.append(sec)
        return rs
    }

    override func buildHistoryData() -> TableViewSectionModel? {
        let history = DataCache.getHistoryTags()
        let cells:[TableViewCellModel] = history.map { (tag) -> TableViewCellModel in
            return TableViewCellModel(id: tag, title: tag, detail: "", cellStyle: .default, accessoryType: .none, data: tag)
        }
        return TableViewSectionModel(id: "historyData", title: "历史标签", rows: cells, data: history)
    }
    
    override var insertItemTitle:String {
        return "新增标签"
    }
     
    override func insertItem(text: String) -> TableViewCellModel {
        let cellModel = super.insertItem(text: text)
        DataCache.addHistoryTag(tag: text)
        return cellModel
    }
    
    func onDone()  {
        let tags = self.tableData[0].rows.map { (cellModel) -> String in
            cellModel.title
        }
        var extra:StockExtra? = DataCache.getStockExtra(code: stock!.code)
        if extra == nil {
            extra = StockExtra(code: stock!.code)
        }
        extra!.tags = tags.joined(separator: ";")
        DataCache.setStockExtra(code: stock!.code, extra: extra!)
    }
    
    @IBAction func onEditButtonClicked(_ sender: UIBarButtonItem) {
        let isEditing = onEdit()
        actionButton.title = isEditing ? "完成" : "编辑"
        if !isEditing {
            self.onDone()
        }
    }
}

