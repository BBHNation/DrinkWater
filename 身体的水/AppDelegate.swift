//
//  AppDelegate.swift
//  身体的水
//
//  Created by Hancock on 2017/1/18.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit
import UserNotifications
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        Bugly.start(withAppId: "cd225684-bd34-41cb-8e7d-235bf50a7012")
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //应用内展示
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 在这里处理通知回调用
        let identity = response.actionIdentifier
        if identity == drinkOneMouseIdentity {
            print("喝一口水")
            BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(getLittleDrink())/1000, complete: {_ in })
        } else if identity == drinkOneCupIdentity {
            print("喝一杯水")
            BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(getCupDrink())/1000, complete: {_ in })
        } else if identity == drinkCustomIdentity {
            print("喝自定义量")
            let text = (response as! UNTextInputNotificationResponse).userText
            let numString = text.trimmingCharacters(in: .decimalDigits) as NSString
            print("喝水\(numString.doubleValue)ml")
            if numString.length < 0 {
                // 都是数字
                print("喝水\(numString.doubleValue)ml")
                BBHealthKitManager.manager.writeDataWithWater(waterNum: numString.doubleValue/1000, complete: {_ in })
            } else {
                // 没有数字
                // 不处理
            }
        }
        BBConnectDataModel.sharedModel.sendMessage(dic: ["code":1024,"content":"reloadComplication"])
        
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

