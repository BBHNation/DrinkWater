//
//  BBSettingDataModel.swift
//  身体的水
//
//  Created by Hancock on 2017/1/19.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit

class BBSettingDataModel: NSObject {
    
    public var age : Int!
    public var height : Int!
    public var weight : Int!
    public var gender : Bool!
    public var littleDrink : Int!
    public var cupDrink : Int!
    static let sharedModel = BBSettingDataModel()
    
    /// 初始化，判断是否已经设置过，如果已经设置过，则使用以前的，没有则重新初始化
    override init(){
        let isSeted = UserDefaults.standard.bool(forKey: "isSetedSettingData")
        if isSeted == true{
            age = UserDefaults.standard.integer(forKey: "age")
            height = UserDefaults.standard.integer(forKey: "height")
            weight = UserDefaults.standard.integer(forKey: "weight")
            gender = UserDefaults.standard.bool(forKey: "gender")
            littleDrink = UserDefaults.standard.integer(forKey: "littleDrink")
            cupDrink = UserDefaults.standard.integer(forKey: "cupDrink")
        }
        else {
            age = 20
            height = 165
            weight = 60
            gender = true
            littleDrink = 30
            cupDrink = 300
        }
        
    }
    
    /// 保存数据到UserDefalt
    public func saveDataToUserDefalt() {
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(height, forKey: "height")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(littleDrink, forKey: "littleDrink")
        UserDefaults.standard.set(cupDrink, forKey: "cupDrink")
        UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(true, forKey: "isSetedSettingData")
        UserDefaults.standard.synchronize()
        
        
        let userDefault = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        userDefault?.set(cupDrink, forKey: CUP_DRINK)
        userDefault?.set(littleDrink, forKey: LITTLE_DRINK)
        userDefault?.set(true, forKey: IS_SETED_MAIN_SETTING)
        userDefault?.synchronize()
        // 向WatchOS同步数据
        BBConnectDataModel.sharedModel.setSession()
        BBConnectDataModel.sharedModel.sendMessage(dic: ["code":1025,"content":[CUP_DRINK:cupDrink,LITTLE_DRINK:littleDrink,"age":age]])
    }
    
    
    

    

}
