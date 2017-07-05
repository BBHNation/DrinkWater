//
//  BBExtensions.swift
//  身体的水
//
//  Created by Hancock on 2017/2/9.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit

extension UIImage {
    public static func DrewCicle(percent:Double) -> UIImage {
        let x = 50+200
        let y = 50+200
        // 圆心
        let r = 200 // 半径
        
        let finalX = Double(x) + Double(r)*sin(percent*360*(M_PI)/180)
        let finalY = Double(y) - Double(r)*cos(percent*360*(M_PI)/180)
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 500, height: 500), false, 0)
        //do some draw ...
        
        //// Color Declarations
        let color = UIColor(red: 0.152, green: 1.000, blue: 0.521, alpha: 0.517)
        let color2 = UIColor(red: 0.063, green: 1.000, blue: 0.414, alpha: 1.000)
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect.init(x: 50, y: 50, width: 400, height: 400))
        color.setStroke()
        ovalPath.lineWidth = 40
        ovalPath.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect.init(x: 230.5, y: 29.5, width: 40, height: 40))
        color2.setFill()
        oval3Path.fill()
        UIColor.clear.setStroke()
        oval3Path.lineWidth = 1
        oval3Path.stroke()
        
        
        //// Oval 4 Drawing
        let oval4Rect = CGRect.init(x: 50, y: 50, width: 400, height: 400)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint.init(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: -90 * CGFloat(M_PI)/180, endAngle: (CGFloat(percent * 360) - 90.0) * CGFloat(M_PI)/180, clockwise: true)
        
        color2.setStroke()
        oval4Path.lineWidth = 40
        oval4Path.stroke()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect.init(x: finalX-20, y: finalY-20, width: 40, height: 40))
        color2.setFill()
        oval2Path.fill()
        UIColor.clear.setStroke()
        oval2Path.lineWidth = 1
        oval2Path.stroke()
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //to do something with the image object
        UIGraphicsEndImageContext()
        
        return image!
    }
}
