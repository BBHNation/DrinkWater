//
//  BBMainWaterIC.swift
//  身体的水
//
//  Created by Hancock on 2017/2/9.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import WatchKit
import Foundation


class BBMainWaterIC: WKInterfaceController {

    @IBOutlet var drewImage: WKInterfaceImage!
    @IBOutlet var backCircleGroup: WKInterfaceGroup!
    @IBOutlet var leftWaterLabel: WKInterfaceLabel!
    var currentPercent: Double = 0.0
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        backCircleGroup.setHeight(156)
    }

    override func willActivate() {
        super.willActivate()
        // 这里做判断，如果数据没变则不动，数据变了则重新绘图
        refreshData()
    }
    
    private func refreshData() {
        BBHealthKitManager.manager.getTotalDrinkCount { [weak self] (drinked, err) in
            guard let strongSelf = self else { return }
            if err != nil { return }
            let percent = drinked / Double(BBSettingDataModel.sharedModel.calculateWaterNum())
            if percent != 0 && percent == strongSelf.currentPercent { return }
            DispatchQueue.main.async {
                strongSelf.backCircleGroup.setBackgroundImage(strongSelf.drewImage.DrewCicle(percent: percent))
                strongSelf.currentPercent = percent
                strongSelf.leftWaterLabel.setText(String.init(format: "%d", BBSettingDataModel.sharedModel.calculateWaterNum() - Int(drinked)))
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
