//
//  iCloudUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/20.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import CloudKit

class iCloudUtils {
    public static func set(anobject:Any?, forKey aKey:String) {
        let store:NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
        store.set(anobject, forKey:aKey)
        store.synchronize()
    }
    public static func object(forKey aKey:String) -> Any? {
        let store:NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default
        return store.object(forKey: aKey)
    }
}
