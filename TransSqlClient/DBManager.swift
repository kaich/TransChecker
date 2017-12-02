//
//  DBManager.swift
//  TransSqlClient
//
//  Created by kai on 2017/11/26.
//  Copyright © 2017年 kai. All rights reserved.
//

import Cocoa
import SQLite
import SwiftyJSON

class PowerMoon {
    var name = ""
    var zhName = ""
    var zhSteps = ""
    var enSteps = ""
    var id: Int64 = 0
}

class DBManager: NSObject {
    
    let db = try! Connection("/Users/kai/Documents/Games/odyssey/FixDB/setup.db")
    var index = -1
    
    let powerMoons = Table("powerMoon")
    let id = Expression<Int64>("id")
    let enSteps = Expression<String?>("en_steps")
    let zhSteps = Expression<String?>("zh_steps")
    let enName = Expression<String>("en_name")
    let zhName = Expression<String>("zh_name")
    
    
    func getItems() -> [Row] {
        var results = [Row]()
        for item in try! db.prepare(powerMoons) {
            results.append(item)
        }
     
        return results
    }
    
    func next() -> PowerMoon? {
        index = index + 1
        if index < getItems().count && index >= 0 {
            return parseItem(getItems()[index])
        }
        else {
            return nil
        }
    }
    
    func previous() -> PowerMoon? {
        index = index - 1
        if index < getItems().count && index >= 0 {
            return parseItem(getItems()[index])
        }
        else {
            return nil
        }
    }
    
    func parseItem(_ row: Row) -> PowerMoon {
        let power = PowerMoon()
        power.name = row[enName]
        power.zhName = row[zhName]
        power.id = row[id]
        
        if let enStepsData = row[self.enSteps]?.data(using: .utf8, allowLossyConversion: false) {
            if let jSONObject = try? JSONSerialization.jsonObject(with: enStepsData, options: .allowFragments) as? [String]{
                power.enSteps = (jSONObject?.joined(separator: "\n"))!
            }
        }

        if let zhStepsData = row[self.zhSteps]?.data(using: .utf8, allowLossyConversion: false) {
            if let jSONObject = try? JSONSerialization.jsonObject(with: zhStepsData, options: .allowFragments) as? [String]{
                power.zhSteps = (jSONObject?.joined(separator: "\n"))!
            }
        }
        
        return power

    }
    
    
    func updateItem(row: PowerMoon, name: String , steps: String) throws {
        
        let item = powerMoons.filter(id == row.id)
        
        try db.run(item.update(zhName <- name))
        
        let jsonArray = steps.split(separator: "\n")
        if let objectData = try? JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            try db.run(item.update(zhSteps <- objectString))
        }
        
     
    }

}
