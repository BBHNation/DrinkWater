//
//  BBHealthKitManager.swift
//  身体的水
//
//  Created by Hancock on 2017/1/26.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

// HealthKit Manager

import UIKit
import HealthKit

class BBHealthKitManager: NSObject {
    // 单例模式
    static let manager = BBHealthKitManager()
    // healthKit store，方便后面使用
    let healthStore = HKHealthStore()
    
    // 初始化，目前无用
    override init() {}
    
    // 申请使用权利
    public func authorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("不支持")
            return
        }
        healthStore.requestAuthorization(toShare: dataTypesToWrite(), read: dataTypesToRead()) { (success, error) in
            if !success {
                print("你没有允许获取健康信息")
            }
            else {
                print("你允许了获取健康信息")
            }
        }
    }
    
//    public func readProfile()
//    func readProfile()->(age:Int?,biologicalsex:HKBiologicalSexObject?,bloodType:HKBloodTypeObject?){
//        
//        //请求年龄
//        var age:Int?
//        let birthDay:NSDate;
//        do {
//            birthDay = try healthStore.dateOfBirthComponents() as NSDate
//            let today = NSDate()
//            let diff = NSCalendar.currentCalendar.components(.Year, fromDate: birthDay, toDate: today, options: NSCalendar.Options(rawValue: 0))
//            age = diff.year
//        }catch {
//            
//        }
//        //请求性别
//        var biologicalSex
//        :HKBiologicalSexObject?
//        do {
//            biologicalSex  = try healthStore.biologicalSex()
//            
//        }catch {
//            
//        }
//        //请求血型
//        var hkbloodType:HKBloodTypeObject?
//        
//        do {
//            hkbloodType = try hkHealthStore.bloodType()
//        }catch{
//            
//        }
//        
//        return (age,biologicalSex,hkbloodType)
//    }
//    
    
    //        var hkbloodType = HKBloodTypeObject()
    //        do {
    //            hkbloodType = try healthStore.bloodType()
    //        } catch {
    //
    //        }
    //
    //        print(hkbloodType)
    
    
    /// 写入喝水数据
    ///
    /// - Parameter waterNum: 喝了多少水量
    public func writeDataWithWater(waterNum : Double) {
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let qutity = HKQuantity(unit: HKUnit.liter(), doubleValue: waterNum)
        let sample = HKQuantitySample(type: type!, quantity: qutity, start: Date(), end: Date())
        healthStore.save(sample) { (success, error) in
            if (success==true) {
                print("成功保存")
            }
            else {
                print("保存失败")
            }
        }
    }
    
    
    /// 需要去写入的health数据
    ///
    /// - Returns: 返回可以写入的HKSampleType
    private func dataTypesToWrite() -> Set<HKSampleType> {
        //for water
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let writeDataTypes: Set<HKSampleType> = [waterType]
        return writeDataTypes
    }
    
    
    /// 需要去读取的health数据
    ///
    /// - Returns: 返回可以读取的HKSampleType
    private func dataTypesToRead() -> Set<HKObjectType> {
        let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let birthdayType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let biologicalSexType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        //for the water
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let readDataTypes: Set<HKObjectType> = [waterType,biologicalSexType,birthdayType,heightType,weightType,dietaryCalorieEnergyType]
        return readDataTypes
    }
    
    
    
}
