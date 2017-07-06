//
//  BBNotificationModel.swift
//  身体的水
//
//  Created by Hancock on 2017/1/19.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import UserNotifications
import SVProgressHUD

let categoryIdentity = "DrinkWater"
let drinkOneMouseIdentity = "DrinkOneMouse" 
let drinkOneCupIdentity = "DrinkOneCup" 
let drinkCustomIdentity = "DrinkCustom"

class BBNotificationModel: NSObject {
    static let sharedModel = BBNotificationModel()
    var beginTimeDouble : Double = 7.0
    var endTimeDouble : Double = 20.0
    var frequencyDouble : Double = 1200.0
    
    
    /// 去除之前所有的本地通知
    public func removeAllNotice() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    
    /// 添加通知
    ///
    /// - Parameters:
    ///   - beginTime: 开始时间
    ///   - endTime: 结束时间
    ///   - frequencyInterval: 频率
    public func addNotification(beginTime : Double, endTime : Double, frequencyInterval : TimeInterval) {
        beginTimeDouble = beginTime
        endTimeDouble = endTime
        frequencyDouble = Double(frequencyInterval)/3600
        
        removeAllNotice()
        registerNotificationCategory()
        
        while beginTimeDouble <= endTimeDouble {
            addNotification(hour: beginTimeDouble, weekend: true)
            beginTimeDouble = beginTimeDouble + frequencyDouble
        }
        
    }
    
    
    /// 本地使用的添加通知
    ///
    /// - Parameters:
    ///   - hour: 小时
    ///   - weekend: 周末
    private func addNotification(hour : Double, weekend : Bool){
        // 使用 UNUserNotificationCenter 来管理通知
        let center = UNUserNotificationCenter.current()
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        let content = UNMutableNotificationContent.init()
        content.title = "该喝水啦！"
        content.body = "快来喝点水吧，身体很渴咯"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = categoryIdentity
        
        // 在 alertTime 后推送本地推送
        let requestId = "water" + "\(hour)"
        
        let hourInt =  Int(hour)
        let minuteInt = Int((hour - Double(hourInt))*60)
        
        var components = DateComponents()
        components.hour = hourInt
        components.minute = minuteInt
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: true)
        let request = UNNotificationRequest.init(identifier: requestId, content: content, trigger: trigger)
        
        //添加推送成功后的处理！
        center.add(request) { (error) in
            print("成功了")
        }
    }
    
    
    /// 注册通知类型
    private func registerNotificationCategory() {
        let drinkWaterCategory: UNNotificationCategory = {
            let inputAction = UNTextInputNotificationAction(identifier: drinkCustomIdentity, title: "自定义", options: UNNotificationActionOptions.destructive, textInputButtonTitle: "就喝这么多", textInputPlaceholder: "输入喝水量（数字），单位毫升")
            
            let drinkOneAction = UNNotificationAction.init(identifier: drinkOneMouseIdentity, title: "喝一口", options: UNNotificationActionOptions.destructive)
            let drinkCupAction = UNNotificationAction.init(identifier: drinkOneCupIdentity, title: "喝一杯", options: UNNotificationActionOptions.destructive)
            return UNNotificationCategory.init(identifier: categoryIdentity, actions: [inputAction, drinkOneAction, drinkCupAction], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
        }()
        
        UNUserNotificationCenter.current().setNotificationCategories([drinkWaterCategory])
    }
}
