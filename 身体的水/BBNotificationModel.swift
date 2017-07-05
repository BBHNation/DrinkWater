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

class BBNotificationModel: NSObject {
    static let sharedModel = BBNotificationModel()
    var beginTimeDouble : Double = 7.0
    var endTimeDouble : Double = 20.0
    var frequencyDouble : Double = 1200.0
    
    public func removeAllNotice() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    public func addNotification(beginTime : Double, endTime : Double, frequencyInterval : TimeInterval) {
        beginTimeDouble = beginTime
        endTimeDouble = endTime
        frequencyDouble = Double(frequencyInterval)/3600
        
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        while beginTimeDouble <= endTimeDouble {
            addNotification(hour: beginTimeDouble, weekend: true)
            beginTimeDouble = beginTimeDouble + frequencyDouble
        }
        
    }
    
    private func addNotification(hour : Double, weekend : Bool){
        // 使用 UNUserNotificationCenter 来管理通知
        let center = UNUserNotificationCenter.current()
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        let content = UNMutableNotificationContent.init()
        content.title = "该喝水啦！"
        content.body = "快来喝点水吧，身体很渴咯，健康的喝水习惯是健康人生的基础"
//        content.sound = UNNotificationSound.init(named: "未命名")
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "helloIdentifier";
        
        // 在 alertTime 后推送本地推送
        
        
        let requestId = "water" + "\(hour)"
        
        let hourInt =  Int(hour)
        let minuteInt = Int((hour - Double(hourInt))*60)
        
        var components = DateComponents()
        components.hour = hourInt
        components.minute = minuteInt
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: true)
        let request = UNNotificationRequest.init(identifier: requestId, content: content, trigger: trigger)
        
//        let enterAction = UNNotificationAction.init(identifier: "enterApp", title: "进入应用", options: UNNotificationActionOptions.foreground)
        
        
//        let enterAction1 = UNNotificationAction.init(identifier: "enterApp", title: "进入应用", options: UNNotificationActionOptions.authenticationRequired)
        
        let ingnoreAction = UNNotificationAction.init(identifier: "ignore", title: "已喝水", options: UNNotificationActionOptions.destructive)
        
        
        let category = UNNotificationCategory.init(identifier: "helloIdentifier", actions: [ingnoreAction], intentIdentifiers: [], options:UNNotificationCategoryOptions.customDismissAction)
        
        center.setNotificationCategories(NSSet.init(array: [category]) as! Set<UNNotificationCategory>)
        
        //添加推送成功后的处理！
        center.add(request) { (error) in
            print("成功了")
        }
    }
}
