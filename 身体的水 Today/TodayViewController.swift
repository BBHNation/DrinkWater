//
//  TodayViewController.swift
//  身体的水 Today
//
//  Created by Hancock on 2017/1/19.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit
import WatchConnectivity
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    var timer : Timer?
        
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var cupButton: FaveButton!
    @IBOutlet weak var littleButton: FaveButton!
    @IBOutlet weak var waterNumLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        circleImage.image = UIImage.DrewCicle(percent: 0.4)
        refreshModel.sharedModel.refreshData()
        reloadData()
        cupButton.isSelected = true
        littleButton.isSelected = true
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    private func getCupDrink() -> Int {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        if dataUserDefaults?.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults?.integer(forKey: CUP_DRINK))!
        }
        else {
            return 300
        }
    }
    
    private func getLittleDrink() -> Int {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        if dataUserDefaults?.bool(forKey: IS_SETED_MAIN_SETTING) == true {
            return (dataUserDefaults?.integer(forKey: LITTLE_DRINK))!
        }
        else {
            return 30
        }
    }
    
    
    @IBAction func drinkOneCup(_ sender: Any) {
        cupButton.isSelected = true
        changeLocalNum(waterNum: -getCupDrink())
    }
    
    @IBAction func drinkLittle(_ sender: Any) {
        littleButton.isSelected = true
        changeLocalNum(waterNum: -getLittleDrink())
    }
    
    
    private func changeLocalNum(waterNum : Int) {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        let oldWaterNum = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        changeAndSaveNumOfWaterLeft(waterNum)
        let newWaterNum = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        changeNumAnimatly(oldWaterNum!, endNum: newWaterNum!)
        if oldWaterNum == 0 {
            return
        }
        BBHealthKitManager.manager.authorization()
        BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(oldWaterNum!-newWaterNum!)/1000)
    }
    
    private func changeNumAnimatly(_ beginNum : Int, endNum : Int) {
        var sub = 1
        if (beginNum-endNum) >= 300{
            sub = 10
        }
        var begin = beginNum
        timer = Timer(fire: Date(), interval: 0.01, repeats: true, block: { (timer) in
            if begin != endNum {
                begin = begin - sub
                self.waterNumLabel.text = "\(begin)"
            }
        })
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    /// 改变并存储今天需要喝的水量
    ///
    /// - Parameter value: 改变多少（带符号）
    func changeAndSaveNumOfWaterLeft(_ value : Int) {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        var waterNum = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        waterNum = waterNum! + value
        if waterNum! < 0 {
            waterNum = 0
        }
        dataUserDefaults?.set(waterNum, forKey: LEFT_WATER_NUM)
        dataUserDefaults?.set(true, forKey: SHARED_USER_DEFALT_CHANGED)
        dataUserDefaults?.synchronize()
    }
    
    
    
    
    func reloadData() {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFALT)
        let waterNum = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        let string = "\(waterNum!)"
        UIView.animate(withDuration: 0.3) {
            self.waterNumLabel.alpha = 0.0
            self.waterNumLabel.text = string
        }
        
        UIView.animate(withDuration: 0.4) {
            self.waterNumLabel.alpha = 1.0
        }
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        reloadData()
        completionHandler(NCUpdateResult.newData)
    }
    
}
