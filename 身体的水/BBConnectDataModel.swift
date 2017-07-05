//
//  BBConnectDataModel.swift
//  身体的水
//
//  Created by Hancock on 2017/1/19.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import WatchConnectivity
import SVProgressHUD

class BBConnectDataModel: NSObject, WCSessionDelegate{
    static let sharedModel = BBConnectDataModel()
    
    override init(){
    }
    
    public func setSession() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        //初始化
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        dataUserDefaults?.set(false, forKey: SHARED_USER_DEFALT_CHANGED)
        dataUserDefaults?.synchronize()
    }
    
    /// 向watch传输更新信息
    func updateData() {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        let num = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        sendMessage(dic: [LEFT_WATER_NUM:num ?? 0])
    }
    
    public func sendMessage(dic : [String:Any]) {
        SVProgressHUD.show(withStatus: "传输中")
        let session = WCSession.default()
        session.sendMessage(dic, replyHandler: { (replyDic) in
            print("成功返回")
            SVProgressHUD.showSuccess(withStatus: "传输成功")
        }) { (error) in
            print("发送失败")
            SVProgressHUD.showError(withStatus: "传输失败")
        }
    }
    
    func leftWaterNum() -> Int{
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        return (dataUserDefaults?.integer(forKey: LEFT_WATER_NUM))!
    }
    
    func saveWaterLeftData(value : Int) {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        dataUserDefaults?.set(value, forKey: LEFT_WATER_NUM)
        dataUserDefaults?.synchronize()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message[LEFT_WATER_NUM] != nil {
            saveWaterLeftData(value: (message[LEFT_WATER_NUM] as! Int))
            print((message[LEFT_WATER_NUM] as! Int))
            
            let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
            dataUserDefaults?.set((message[LEFT_WATER_NUM] as! Int), forKey: LEFT_WATER_NUM)
        }
        else if (message["code"] as? String) == SHARED_USER_DEFALT_CHANGED {
            replyHandler([LEFT_WATER_NUM:leftWaterNum(),CUP_DRINK:BBSettingDataModel.sharedModel.cupDrink,LITTLE_DRINK:BBSettingDataModel.sharedModel.littleDrink])
        }
    }
    
    
}
