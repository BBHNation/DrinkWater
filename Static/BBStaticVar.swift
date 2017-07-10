//
//  BBStaticVar.swift
//  身体的水
//
//  Created by Hancock on 2017/1/20.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

// 静态数据

import Foundation

let LEFT_WATER_NUM = "waterNumLeft"// 剩下的水量
let SHARED_USER_DEFAULT = "group.cn.iceFrozen.waterOfLife"// group共享defalt
let SHARED_DATE = "group.cn.bbh.bodyWater.date"// 共享的日期，用来设置更新
let IS_SETED_DATE = "is.seted.date"// 是否设置了日期
let SHARED_USER_DEFALT_CHANGED = "group.cn.bbh.bodyWater.isChanged"// 通知：水量是否被修改
let NOTICE_SWITCH_ON = "noticeSwitchOn"// 通知是否打开了
let CUP_DRINK = "cupDrinkWater"// 一杯水
let LITTLE_DRINK = "littleDrinkWater"// 一口水
let IS_SETED_MAIN_SETTING = "isSettedMainSetting"// 是否设置了user主要数据
let NEWEST_DRINKED_WATER_NUM_KEY = "newestDrinkedWaterNumKey"// 保存每一次从HeathKit中获取的喝水量，方便在锁屏的时候使用
let TEMPERATURE_KEY = "temperatureKey"// 保存当前的温度，每次请求后刷新
let WEATHER_DATE_AND_TEMPERATURE_KEY = "weatherDateAndTemperatureCacheKey"// 保存上一次刷新天气的时间和温度情况（是一个字典），刷新时候需要做一个判断，如果缓存的天气没有超过半个小时，使用之前的

extension String {
    // url encode
    var urlEncode : String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    // url decode
    var urlDecode : String {
        return self.removingPercentEncoding!
    }
}

/// 每日刷新使用的Model
class refreshModel : NSObject{
    // 单例模式
    static let sharedModel = refreshModel()
    
    
    /// 初始化
    override init() {
        // 初始化，获取group的UserDefalt
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        // 判断是否已经存在bool值设置了日期
        var isSetedDate = dataUserDefaults?.bool(forKey: IS_SETED_DATE)
        if isSetedDate==false {
            // 如果没有设置，进行设置
            isSetedDate = true
            dataUserDefaults?.set(isSetedDate, forKey: IS_SETED_DATE)
            dataUserDefaults?.set(Date(), forKey: SHARED_DATE)
            dataUserDefaults?.synchronize()
        }
    }
    
    
    
    /// 刷新日期
    public func refreshData() {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        let isSetedDate = dataUserDefaults?.bool(forKey: IS_SETED_DATE)
        if isSetedDate==true {
            // 如果已经设置日期，判断日期与今天是否相同
            let date = dataUserDefaults?.object(forKey: SHARED_DATE) as? Date
            let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let comOld = calender?.components([NSCalendar.Unit.day,NSCalendar.Unit.month], from: date!)
            let comNew = calender?.components([NSCalendar.Unit.day,NSCalendar.Unit.month], from: Date())
            
            // 判断和今天是否相同
            if comNew?.day==comOld?.day && comNew?.month==comOld?.month {
                // 相同
                // do nothing
                return
            }
            else {
                // 不相同，则修改日期，并刷新数据
                // final 是计算model计算出来的
                let final = calculateWaterNum()
                dataUserDefaults?.set(final, forKey: LEFT_WATER_NUM)
                dataUserDefaults?.set(Date(), forKey: SHARED_DATE)
                dataUserDefaults?.synchronize()
            }
        }
    }
    
    

}

/// 根据人体数据来计算一天的喝水量，以后会加入天气情况
///
/// - Returns: 返回一天的喝水量
public func calculateWaterNum() -> Int{
    
    var waterNum = 1300
#if os(iOS)
    let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
    let age: Int? = dataUserDefaults?.value(forKey: "age") as! Int?
#elseif os(watchOS)
    let dataUserDefaults = UserDefaults.standard
    let age: Int? = dataUserDefaults.value(forKey: "age") as! Int?
#endif
    if age == nil {
        return waterNum
    }
    else if age! >= 10 && age! <= 40 {
        waterNum = waterNum + 300
    }else {
        waterNum = waterNum + 500
    }
    
    // 这里是关于天气的处理
//    guard let temperatureNow = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)?.value(forKey: TEMPERATURE_KEY) as! Double? else {
//        return waterNum
//    }
//    if temperatureNow > 30.0{
//        waterNum += 200
//    }
    
    return waterNum
}

/// 通过UserDefaults获取喝一杯水的量
///
/// - Returns: 返回Int一杯水的毫升数
public func getCupDrink() -> Int {
    #if os(iOS)
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        if dataUserDefaults?.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults!.integer(forKey: CUP_DRINK))
        }
        else {
            return 300
        }
    #elseif os(watchOS)
        let dataUserDefaults = UserDefaults.standard
        if dataUserDefaults.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults.integer(forKey: CUP_DRINK))
        }
        else {
            return 300
        }
    #endif
}


/// 通过UserDefaults获取喝一口水的量
///
/// - Returns: 返回Int一口水的量
public func getLittleDrink() -> Int {
    #if os(iOS)
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        if dataUserDefaults?.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults!.integer(forKey: LITTLE_DRINK))
        }
        else {
            return 30
        }
    #elseif os(watchOS)
        let dataUserDefaults = UserDefaults.standard
        if dataUserDefaults.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults.integer(forKey: LITTLE_DRINK))
        }
        else {
            return 30
        }
    #endif
}
