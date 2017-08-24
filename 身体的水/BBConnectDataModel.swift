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
    let session = WCSession.default()
    override init(){}
    
    /// 初始化后设置Session
    public func setSession() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        //初始化
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        dataUserDefaults?.set(false, forKey: SHARED_USER_DEFALT_CHANGED)
        dataUserDefaults?.synchronize()
    }
    
    /// 向watch传输更新信息
    func updateData() {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        let num = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        sendMessage(dic: [LEFT_WATER_NUM:num ?? 0])
    }
    
    
    /// 发送消息
    ///
    /// - Parameter dic: 向Watch发送消息，消息格式是 [String : Any]
    public func sendMessage(dic : [String:Any]) {
        SVProgressHUD.show(withStatus: "向Watch传输数据中\n请打开Watch APP")
        session.sendMessage(dic, replyHandler: { (replyDic) in
            print("成功返回")
            SVProgressHUD.showSuccess(withStatus: "传输成功")
        }) { (error) in
            print("发送失败")
            SVProgressHUD.showError(withStatus: "传输失败")
        }
    }
    
    
    /// 获取还剩多少水没喝
    ///
    /// - Returns: 返回Int值，表示还剩多少水要喝
    func leftWaterNum() -> Int{
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        return (dataUserDefaults?.integer(forKey: LEFT_WATER_NUM))!
    }
    
    
    /// 保存剩下没喝的水量
    ///
    /// - Parameter value: 还剩多少水没有喝
    func saveWaterLeftData(value : Int) {
        // 这里使用的是共享的UserDefault来同步数据，需要修改
        // 直接使用健康应用中记录的喝水量来计算还剩余多少水需要喝
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        dataUserDefaults?.set(value, forKey: LEFT_WATER_NUM)
        dataUserDefaults?.synchronize()
    }
    
    
    // MARK: - 一些协议方法
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message[LEFT_WATER_NUM] != nil {
            saveWaterLeftData(value: (message[LEFT_WATER_NUM] as! Int))
            print((message[LEFT_WATER_NUM] as! Int))
            
            let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
            dataUserDefaults?.set((message[LEFT_WATER_NUM] as! Int), forKey: LEFT_WATER_NUM)
        }
        else if (message["code"] as? String) == SHARED_USER_DEFALT_CHANGED {
            replyHandler([LEFT_WATER_NUM:leftWaterNum(),CUP_DRINK:BBSettingDataModel.sharedModel.cupDrink,LITTLE_DRINK:BBSettingDataModel.sharedModel.littleDrink])
        }
    }
}
