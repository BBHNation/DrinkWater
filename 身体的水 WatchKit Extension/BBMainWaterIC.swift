//
//  BBMainWaterIC.swift
//  身体的水
//
//  Created by Hancock on 2017/2/9.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import Foundation


let notificationName = "HasDrinkedWater"
class BBMainWaterIC: WKInterfaceController {

    @IBOutlet var drewImage: WKInterfaceImage!
    @IBOutlet var backCircleGroup: WKInterfaceGroup!
    @IBOutlet var leftWaterLabel: WKInterfaceLabel!
    @IBOutlet var noticeLabel : WKInterfaceLabel!
    
    var currentPercent: Double = 0.0
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        backCircleGroup.setHeight(156)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: NSNotification.Name.init(notificationName), object: nil)
    }
    @objc func receiveNotification() {
        refreshData()
    }

    override func willActivate() {
        super.willActivate()
        BBConnectModel.sharedModel.setSession();
        // 这里做判断，如果数据没变则不动，数据变了则重新绘图
        refreshData()
    }
    
    @IBAction func refreshView() {
        refreshData()
    }
    private func refreshData() {
        BBHealthKitManager.manager.getTotalDrinkCount { [weak self] (drinked, err) in
            guard let strongSelf = self else { return }
            if err != nil { return }
            let percent = drinked / Double(calculateWaterNum())
            if percent != 0 && percent == strongSelf.currentPercent { return }
            DispatchQueue.main.async {
                strongSelf.backCircleGroup.setBackgroundImage(strongSelf.drewImage.DrewCicle(percent: percent))
                strongSelf.currentPercent = percent
                strongSelf.leftWaterLabel.setText(String.init(format: "%d", abs(calculateWaterNum() - Int(drinked))))
                if calculateWaterNum() - Int(drinked) < 0 {
                    strongSelf.noticeLabel.setText("额外喝水")
                } else {
                    strongSelf.noticeLabel.setText("需要喝水")
                }
                BBConnectModel.sharedModel.reloadTimeLineData()
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
