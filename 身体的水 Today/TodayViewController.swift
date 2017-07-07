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
    @IBOutlet weak var waterCupLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var drinkNoticeLabel: UILabel!
    
    let totalWaterToDrink = calculateWaterNum()
    var leftWater = calculateWaterNum()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleImage.image = UIImage.DrewCicle(percent: 1.0)
        refreshModel.sharedModel.refreshData()
        reloadData()
        cupButton.isSelected = true
        littleButton.isSelected = true
        loadWeatherInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    /// 获取天气情况
    private func loadWeatherInfo() {
        BBLocationAndWeatherManger.manager.getCityAndWeatherInfo { [weak self] (cityname, temperature, describe, code, err) in
            guard let strongSelf = self else { return }
            if err != nil {
                print("err is \(String(describing: err?.localizedDescription))")
                return
            }
            print("\(String(describing: cityname)) \(String(describing: temperature))C \(String(describing: describe))")
            DispatchQueue.main.async {
                strongSelf.weatherLabel.text = "\(cityname ?? " ") \(temperature ?? " ")C \(describe ?? " ")"
                
                guard let c = code else { return }
                strongSelf.weatherIcon.image = UIImage.init(named: "\(c).png")
                
                guard let tem = temperature else { return }
                let temNum = Double(tem)
                // 温度的一些处理
                if temNum != nil {
                    if temNum! > 30.0 {
                        strongSelf.adviceLabel.text = "天气炎热，建议增加喝水量"
                    }
                    else {
                        strongSelf.adviceLabel.text = "健康饮水，健康生活"
                    }
                }
                
            }
        }
    }

    
    
    /// 点击按钮，喝一杯水
    @IBAction func drinkOneCup(_ sender: Any) {
        cupButton.isSelected = true
        changeLocalNum(waterNum: getCupDrink())
    }
    
    /// 点击按钮，喝一口水
    @IBAction func drinkLittle(_ sender: Any) {
        littleButton.isSelected = true
        changeLocalNum(waterNum: getLittleDrink())
    }
    
    
    
    /// 改变本地数据
    ///
    /// - Parameter waterNum: 输入Int为喝了多少水
    private func changeLocalNum(waterNum : Int) {
        changeNumAnimatly(leftWater, endNum: leftWater-waterNum)
        leftWater -= waterNum
        BBHealthKitManager.manager.authorization()
        BBHealthKitManager.manager.writeDataWithWater(waterNum:Double(waterNum)/1000)
    }
    
    
    /// 在插件界面动画的修改喝了多少水
    ///
    /// - Parameters:
    ///   - beginNum: 起始有多少水
    ///   - endNum: 终止为多少水
    private func changeNumAnimatly(_ beginNum : Int, endNum : Int) {
        var sub = 1
        if (beginNum-endNum) >= getCupDrink() {
            // 设置步长
            sub = 10
        }
        // 开始递归
        var begin = beginNum
        timer = Timer(fire: Date(), interval: 0.01, repeats: true, block: { (timer) in
            if begin != endNum {
                begin = begin - sub
                self.waterNumLabel.text = "\(abs(begin))"
                self.waterCupLabel.text = String.init(format: "%.1f", ((Double(abs(begin))/Double(getCupDrink()))))
            }
            else {
                // 修改圆圈
                BBHealthKitManager.manager.getTotalDrinkCount(completion: { [weak self] (drinked, err) in
                    guard let strongSelf = self else {return}
                    if err != nil { return }
                    let queue = DispatchQueue.main
                    queue.async(execute: {
                        
                        let persent = drinked/Double(strongSelf.totalWaterToDrink)
                        strongSelf.circleImage.image = UIImage.DrewCicle(percent: persent)
                        if persent >= 1.0 {
                            strongSelf.noticeLabel.text = "恭喜你！\n完成任务"
                            strongSelf.drinkNoticeLabel.text = "额外喝水"
                        }
                    })
                })
                self.timer?.invalidate()
                self.timer = nil
            }
        })
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    /// 改变并存储今天需要喝的水量
    ///
    /// - Parameter value: 改变多少（带符号）
    func changeAndSaveNumOfWaterLeft(_ value : Int) {
        let dataUserDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        var waterNum = dataUserDefaults?.integer(forKey: LEFT_WATER_NUM)
        waterNum = waterNum! + value
        if waterNum! < 0 {
            waterNum = 0
        }
        dataUserDefaults?.set(waterNum, forKey: LEFT_WATER_NUM)
        dataUserDefaults?.set(true, forKey: SHARED_USER_DEFALT_CHANGED)
        dataUserDefaults?.synchronize()
    }
    
    
    
    /// 刷新数据
    func reloadData() {
        UIView.animate(withDuration: 0.3) {
            self.waterNumLabel.alpha = 0.0
            self.waterCupLabel.alpha = 0.0
            BBHealthKitManager.manager.getTotalDrinkCount(completion: { [weak self] (drinked, err) in
                guard let strongSelf = self else { return }
                if err != nil {
                    // 获取数据错误
                    DispatchQueue.main.sync {
                        guard let strongSelf = self else { return }
                        strongSelf.noticeLabel.text = "请解锁手机\n并点击以\n刷新界面"
                        strongSelf.adviceLabel.text = "锁屏无法获取健康数据"
                        strongSelf.cupButton.isUserInteractionEnabled = false
                        strongSelf.littleButton.isUserInteractionEnabled = false
                    }
                    return
                }
                DispatchQueue.main.async(execute: {
                    // 恢复UI
                    strongSelf.cupButton.isUserInteractionEnabled = true
                    strongSelf.littleButton.isUserInteractionEnabled = true
                    strongSelf.noticeLabel.text = "点击水滴\n记录喝水"
                    strongSelf.drinkNoticeLabel.text = "需要喝水"
                    
                    
                    let percent = drinked/Double(strongSelf.totalWaterToDrink)
                    let left = strongSelf.totalWaterToDrink - Int(drinked)
                    strongSelf.leftWater = left
                    strongSelf.waterNumLabel.text = "\(abs(left))"
                    strongSelf.waterCupLabel.text = String.init(format: "%.1f", Double(abs(left))/Double(getCupDrink()))
                    
                    
                    if percent >= 1 {
                        strongSelf.noticeLabel.text = "恭喜你！\n完成任务"
                        strongSelf.drinkNoticeLabel.text = "额外喝水"
                    }
                    strongSelf.circleImage.image = UIImage.DrewCicle(percent: percent)
                })
            })
        }
        
        UIView.animate(withDuration: 0.4) {
            self.waterNumLabel.alpha = 1.0
            self.waterCupLabel.alpha = 1.0
        }
 
    }
    
    @IBAction func tapLabelToReloadData(_ sender: Any) {
        BBHealthKitManager.manager.getTotalDrinkCount { [weak self](_, err) in
            guard let strongSelf = self else { return }
            if err == nil {
                if strongSelf.cupButton.isUserInteractionEnabled == false && strongSelf.littleButton.isUserInteractionEnabled == false {
                    strongSelf.cupButton.isUserInteractionEnabled = true
                    strongSelf.littleButton.isUserInteractionEnabled = true
                    strongSelf.reloadData()
                }
            }
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
