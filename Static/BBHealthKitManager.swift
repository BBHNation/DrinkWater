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
    
    
    /// 获取今天喝了多少水
    ///
    /// - Parameter completion: 参数是一个处理函数
    func getTotalDrinkCount(completion: @escaping (Double, Error?) -> ()) {
        var query: HKQuery?
        let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)
        let timeSortDescriptor = NSSortDescriptor.init(key: HKSampleSortIdentifierEndDate, ascending: false)
        let predicate = predicateForSamplesToday()
        
        query = HKSampleQuery.init(sampleType: waterType!, predicate: predicate, limit: 0, sortDescriptors: [timeSortDescriptor], resultsHandler: { (qurry, results, err) in
            if err != nil {
                completion(0, err)
            } else {
                var totalWater = 0.0;
                for quantitySample in results! {
                    let quantity = (quantitySample as! HKQuantitySample).quantity
                    let waterUnit = HKUnit.literUnit(with: .milli)
                    let userWater = quantity.doubleValue(for: waterUnit)
                    totalWater += userWater
                }
                completion(totalWater, nil)
            }
        })
        self.healthStore.execute(query!)
    }
    
    
    /// 获取今天的Predicate
    ///
    /// - Returns: 返回今天的Predicate
    private func predicateForSamplesToday() -> NSPredicate{
        let calender = Calendar.current
        let now = Date()
        
        var components = calender.dateComponents([.day,.month,.year], from: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let startDate = calender.date(from: components)
        let endDate = calender.date(byAdding: .day, value: 1, to: startDate!)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        return predicate
    }
    
    
    
    
    
}
