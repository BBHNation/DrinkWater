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
let SHARED_USER_DEFALT = "group.cn.iceFrozen.waterOfLife"// group共享defalt
let SHARED_DATE = "group.cn.bbh.bodyWater.date"// 共享的日期，用来设置更新
let IS_SETED_DATE = "is.seted.date"// 是否设置了日期
let SHARED_USER_DEFALT_CHANGED = "group.cn.bbh.bodyWater.isChanged"// 通知：水量是否被修改
let NOTICE_SWITCH_ON = "noticeSwitchOn"// 通知是否打开了
let CUP_DRINK = "cupDrinkWater"// 一杯水
let LITTLE_DRINK = "littleDrinkWater"// 一口水
let IS_SETED_MAIN_SETTING = "isSettedMainSetting"// 是否设置了user主要数据


/// 每日刷新使用的Model
class refreshModel : NSObject{
    // 单例模式
    static let sharedModel = refreshModel()
    
    
    /// 初始化
    override init() {
        // 初始化，获取group的UserDefalt
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
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
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
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
                let final = BBSettingDataModel.sharedModel.calculateWaterNum()
                dataUserDefaults?.set(final, forKey: LEFT_WATER_NUM)
                dataUserDefaults?.set(Date(), forKey: SHARED_DATE)
                dataUserDefaults?.synchronize()
            }
        }
    }
}
