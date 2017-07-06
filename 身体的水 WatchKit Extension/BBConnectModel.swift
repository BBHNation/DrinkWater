//
//  BBConnectModel.swift
//  身体的水
//
//  Created by Hancock on 2017/1/18.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import WatchConnectivity

class BBConnectModel: NSObject,WCSessionDelegate {
    static let sharedModel = BBConnectModel()//单例模式
    private var waterNum : Int?
    override init() {
        if waterNum == nil {
            waterNum = UserDefaults.standard.integer(forKey: LEFT_WATER_NUM)
        }
    }
    
    
    /// 设置Session
    func setSession() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    /// 与手机同步数据
    func synchronizeDataWithPhone() {
        WCSession.default().sendMessage(["code":SHARED_USER_DEFALT_CHANGED], replyHandler: { (replyDic)  in
            if replyDic[LEFT_WATER_NUM] != nil {
//                let oldWaterNum = self.leftWaterNumToday()
//                if oldWaterNum < (replyDic[LEFT_WATER_NUM] as! Int) {
//                    //do nothing
//                    //同步回来的数据不是最新的，本地才是最新的
//                    //丢弃数据
//                }
//                else {
                    self.waterNum = replyDic[LEFT_WATER_NUM] as? Int
                    NotificationCenter.default.post(name: NSNotification.Name.init("waterChange"), object: nil)
                    UserDefaults.standard.set(replyDic[LEFT_WATER_NUM], forKey: LEFT_WATER_NUM)
                    self.reloadTimeLineData()
//                }
            }
            
            if replyDic[CUP_DRINK] != nil && replyDic[LITTLE_DRINK] != nil{
                UserDefaults.standard.set(replyDic[CUP_DRINK], forKey: CUP_DRINK)
                UserDefaults.standard.set(replyDic[LITTLE_DRINK], forKey: LITTLE_DRINK)
                UserDefaults.standard.set(true, forKey: IS_SETED_MAIN_SETTING)
                UserDefaults.standard.synchronize()
            }
            
            
        }) { (error) in
            
        }
    }
    
    
    /// 更新表盘
    func reloadTimeLineData() {
        //更新表盘
        let complicationServer = CLKComplicationServer.sharedInstance()
        for complication in complicationServer.activeComplications! {
            complicationServer.reloadTimeline(for: complication)
        }
    }
    
    
    /// 今日剩下还要喝的水的量
    ///
    /// - Returns: 返回剩下多少水
    func leftWaterNumToday() -> Int {
        if waterNum == nil {
            waterNum = UserDefaults.standard.integer(forKey: LEFT_WATER_NUM)
        }
        return waterNum!
    }
    
    
    /// 改变并存储今天需要喝的水量
    ///
    /// - Parameter value: 改变多少（带符号）
    func changeAndSaveNumOfWaterLeft(value : Int) {
        let num = leftWaterNumToday()
        var numNew = num + value
        if numNew < 0 {
            numNew = 0
        }
        waterNum = numNew
        UserDefaults.standard.set(waterNum, forKey: LEFT_WATER_NUM)
        UserDefaults.standard.synchronize()
        BBHealthKitManager.manager.authorization()
        BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(num-numNew)/1000)
        updateData()
    }
    
    
    /// 向iphone传输更新信息
    func updateData() {
        let num = leftWaterNumToday()
        sendMassage(dic: [LEFT_WATER_NUM:num])
    }
    
    
    /// 传输信息
    ///
    /// - Parameter dic: 需要传输的字典
    func sendMassage(dic : [String:Any]) {
        WCSession.default().sendMessage(dic , replyHandler: { (replyDic) in
            
        }) { (error) in
            
        }
    }
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    /// 收到的信息在这里
    ///
    /// - Parameters:
    ///   - session: 接收到信息的session‘
    ///   - message: 接收到的dic
    ///   - replyHandler: 需要返回的信息
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        waterNum = message[LEFT_WATER_NUM] as? Int;
        if waterNum != nil {
            NotificationCenter.default.post(name: NSNotification.Name.init("waterChange"), object: nil)
            UserDefaults.standard.set(waterNum, forKey: LEFT_WATER_NUM)
            reloadTimeLineData()
            replyHandler(["good":"good"])
        }
        
        guard let code = message["code"] as! Int? else { return }
        if code == 1024 {
            reloadTimeLineData()
        }
        else if code == 1025 {
            let cupDrink: Int? = (message["content"] as? Dictionary)?[CUP_DRINK]
            let littleDrink: Int? = (message["content"] as? Dictionary)?[LITTLE_DRINK]
            let age: Int? = (message["content"] as? Dictionary)?["age"]
            UserDefaults.standard.set(cupDrink, forKey: CUP_DRINK)
            UserDefaults.standard.set(littleDrink, forKey: LITTLE_DRINK)
            UserDefaults.standard.set(age, forKey: "age")
            UserDefaults.standard.synchronize()
        }
    }
    
}
