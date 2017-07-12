//
//  BBDrinkIC.swift
//  身体的水
//
//  Created by Hancock on 2017/2/9.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import Foundation

enum DrinkType {
    case CUP
    case LITTLE
}
class BBDrinkIC: WKInterfaceController {

    @IBOutlet var animationImage: WKInterfaceImage!
    @IBOutlet var contentGroup: WKInterfaceGroup!
    @IBOutlet var animationGroup: WKInterfaceGroup!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    @IBAction func drinkACup(_ sender: Any) {
        //喝一杯
        print("喝一杯")
        setDrinking()
        BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(getCupDrink())/1000, complete: {_ in })
    }
    @IBAction func drinkAMouse(_ sender: Any) {
        //喝一口
        print("喝一口")
        setDrinking()
        BBHealthKitManager.manager.writeDataWithWater(waterNum: Double(getLittleDrink())/1000, complete: {_ in })
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name.init(notificationName), object: nil)
    }
    
    /// 开始喝水动画
    private func setDrinking() {
        self.animate(withDuration: 0.5) {
            [weak self] in
            if let strongSelf = self {
                strongSelf.contentGroup.setAlpha(0.0)
            }
        }
        let time: TimeInterval = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
            [weak self] in
            if let strongSelf = self{
                strongSelf.animationGroup.setHidden(false)
                strongSelf.contentGroup.setHidden(true)
                strongSelf.animationImage.startAnimating()
            }
        }
        
        let timeTwo: TimeInterval = 1.3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+timeTwo) {
            [weak self] in
            if let strongSelf = self{
                strongSelf.stopDrinking()
            }
        }
    }
    
    /// 结束喝水动画
    private func stopDrinking() {
        animationGroup.setHidden(true)
        contentGroup.setHidden(false)
        animationImage.stopAnimating()
        self.animate(withDuration: 0.5) {
            [weak self] in
            if let strongSelf = self {
                strongSelf.contentGroup.setAlpha(1.0)
                WKInterfaceDevice.current().play(WKHapticType.success)
            }
        }
        BBConnectModel.sharedModel.reloadTimeLineData()
        postNotification()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
