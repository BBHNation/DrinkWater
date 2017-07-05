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
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        backCircleGroup.setHeight(156)
        backCircleGroup.setBackgroundImage(drewImage.DrewCicle(percent: 0.3))
    }

    override func willActivate() {
        super.willActivate()
        // 这里做判断，如果数据没变则不动，数据变了则重新绘图
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
