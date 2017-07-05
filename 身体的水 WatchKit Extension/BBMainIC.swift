//
//  BBMainIC.swift
//  身体的水
//
//  Created by Hancock on 2017/1/18.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import Foundation



class BBMainIC: WKInterfaceController {

    
    @IBOutlet var contentGroup: WKInterfaceGroup!
    @IBOutlet var animationImage: WKInterfaceImage!
    @IBOutlet var animationGroup: WKInterfaceGroup!
    @IBOutlet var waterLabel: WKInterfaceLabel!
    @IBOutlet var chooseGroup: WKInterfaceGroup!
    @IBOutlet var imagesGroup: WKInterfaceGroup!
    @IBOutlet var describGroup: WKInterfaceGroup!
    var timer : Timer?
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    
    private func getWaterNum(isCup : Bool) -> Int {
        if isCup == true {
            if UserDefaults.standard.bool(forKey: IS_SETED_MAIN_SETTING) == true {
                return UserDefaults.standard.integer(forKey: CUP_DRINK)
            }
            else {
                return 300
            }
        }
        
        else if isCup == false {
            if UserDefaults.standard.bool(forKey: IS_SETED_MAIN_SETTING) == true {
                return UserDefaults.standard.integer(forKey: LITTLE_DRINK)
            }
            else {
                return 30
            }
        }
        else {
            return -1
        }
    }
    
    
    private func changeNumOfWater(type : DrinkType){
        if type == DrinkType.CUP {
            BBConnectModel.sharedModel.changeAndSaveNumOfWaterLeft(value: -getWaterNum(isCup: true))
        }else if type == DrinkType.LITTLE {
            BBConnectModel.sharedModel.changeAndSaveNumOfWaterLeft(value: -getWaterNum(isCup: false))
        }
        
        setDrinking()
        BBConnectModel.sharedModel.reloadTimeLineData()
    }
    
    
    @IBAction func drinkLittle(_ sender: Any) {
        changeNumOfWater(type: DrinkType.LITTLE)
    }
    @IBAction func drinkCup(_ sender: Any) {
        changeNumOfWater(type: DrinkType.CUP)
    }
    
    
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
                strongSelf.reloadData()
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
    }
    
    @IBAction func synchoronizeWithPhone() {
        BBConnectModel.sharedModel.synchronizeDataWithPhone()
    }
    override func willActivate() {
        super.willActivate()
        BBConnectModel.sharedModel.setSession();
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name.init("waterChange"), object: nil)
        reloadData()
        BBConnectModel.sharedModel.synchronizeDataWithPhone()
    }

    override func didDeactivate() {
        super.didDeactivate()
        timer?.invalidate()
        timer = nil
    }
    
    public func reloadData(){
        let string = "\(BBConnectModel.sharedModel.leftWaterNumToday())"
        waterLabel.setText(string)
        BBConnectModel.sharedModel.reloadTimeLineData()
    }

}
