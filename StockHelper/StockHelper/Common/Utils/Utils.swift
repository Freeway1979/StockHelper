//
//  Utils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    /// 打开同花顺
    public static func openTHS(with code:String = "") {
        // UIPasteboard.general.string = code
        let url = URL(string: "AMIHexinPro://cn.com.10jqka.eq")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (rs) in
                print("Succuess \(rs)")
            }
        }
    }
    
    public static func openWenCai(from viewController:UIViewController) {
        WebViewController.open(website: WebSite.WenCai, withtitle: "问财", from: viewController.navigationController!)
    }
    
    public static func parseJSONStringToObjects<T:Decodable>(jsonString:String) -> [T] {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let objects = try! decoder.decode([T].self, from: jsonData)
        return objects;
    }
    
    public static func parseJSONGBKStringToObjects<T:Decodable>(jsonString:String) -> [T] {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let jsonData:Data = jsonString.data(using: String.Encoding(rawValue: enc))!

        let decoder = JSONDecoder()
        let objects = try! decoder.decode([T].self, from: jsonData)
        return objects;
    }
    
    public static func appInitialize() {
        DispatchQueue.global().async {
            DataCache.loadFromDB();
            DataCache.loadStockExtras()
            DataCache.loadHistoryTags()
        }
    }
    
    public static func getNumberString(serverData:Any) -> String {
        var rs:String = "0"
        if serverData is NSNumber {
            rs = (serverData as? NSNumber)?.stringValue ?? "0"
        }
        if serverData is String {
            rs = serverData as? String ?? "0"
        }
        if rs == "--" {
            return "0"
        }
        return rs
    }
    
    public static func getNumber(serverData:Any) -> NSNumber {
        var rs:NSNumber = 0
        if serverData is NSNumber {
            rs = (serverData as? NSNumber ?? 0)
        }
        if serverData is String {
            if (serverData as! String) != "--" {
                rs = (serverData as! String).numberValue ?? 0
            }
        }
        return rs
    }
    
    
    //IO
    public static func loadPersistantData(key:String, iCloud:Bool = true) -> Any? {
        var data = UserDefaults.standard.object(forKey: key)
        if data == nil {
            if iCloud {
                //iCloud
                data = iCloudUtils.object(forKey: key)
            }
        }
        return data
    }
    
    public static func savePersistantData(key:String, data:Any?, iCloud:Bool = true) {
        UserDefaults.standard.set(data, forKey:key)
        UserDefaults.standard.synchronize()
        if iCloud {
            //iCloud
            iCloudUtils.set(anobject: data, forKey: key)
        }
    }
    
    public static func loadPersistantArrayJsonData<T>(key:String) -> [T]? where T:Codable {
        do {
            let data = Utils.loadPersistantData(key: key)
            if (data != nil)
            {
                let rs = try JSONDecoder().decode([T].self, from: data! as! Data)
                return rs
            }
        } catch {
            print(error.localizedDescription)
        }
        return [];
    }
    
    public static func savePersistantJsonData<T>(key:String, data:T?) where T:Encodable {
         do {
             let jsonData = try JSONEncoder().encode(data)
             Utils.savePersistantData(key: key, data: jsonData)
         } catch {
             print(error.localizedDescription)
         }
    }
}
