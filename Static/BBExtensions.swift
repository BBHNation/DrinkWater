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
        
        let finalX = Double(x) + Double(r)*sin(percent*360*(Double.pi)/180)
        let finalY = Double(y) - Double(r)*cos(percent*360*(Double.pi)/180)
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 500, height: 500), false, 0)
        //do some draw ...
        
        //// Color Declarations
        let color = UIColor(red: 0.152, green: 1.000, blue: 0.521, alpha: 0.517)
        let color2 = UIColor(red: 0.06, green: 1.000, blue: 0.414, alpha: 1.000)
        
        
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
        oval4Path.addArc(withCenter: CGPoint.init(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: -90 * CGFloat(Double.pi)/180, endAngle: (CGFloat(percent * 360) - 90.0) * CGFloat(Double.pi)/180, clockwise: true)
        
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

extension CAShapeLayer {
    func addCircleAnimation(duration: TimeInterval, from: CGFloat, to: CGFloat) -> CAShapeLayer {
        // 创建动画
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = from/to
        animation.toValue = 1
        animation.duration = duration
        self.add(animation, forKey: "strokeEndAnimation")
        return self
    }
    
    func addShadow() -> CALayer {
        // Create shadow layer
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.insertSublayer(self, at: 0)
        
        // Shadow path animation
        let shadowPathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "shadowPath")
        shadowPathAnimation.fromValue = 0.0
        shadowPathAnimation.toValue = self.path
        shadowLayer.add(shadowPathAnimation, forKey: "shadowPathAnimation")
        
        return shadowLayer
    }
    
    func addColorAnimation(duration: TimeInterval, fromPercent: CGFloat?, toPercent: CGFloat) {
        let animation = CABasicAnimation.init(keyPath: "strokeColor")
        if fromPercent == nil {
            animation.fromValue = UIColor.red.cgColor
        }
        else {
            animation.fromValue = UIView.getColorFromPercent(percent: fromPercent!)
        }
        animation.toValue = UIView.getColorFromPercent(percent: toPercent)
        animation.duration = duration
        self.add(animation, forKey: "strokeColorAnimation")
    }
}

extension CALayer {
    func addGradientLayer(rect: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.mask = self
        return gradientLayer
    }
}



extension UIView {
    
    public func drawBackGroundCircle() {
        let greenColor_Alpha = UIColor.init(red: 0.1, green: 1.0, blue: 0.3, alpha: 0.3).cgColor
        let length = self.frame.width
        self.layer.addSublayer(circleLayerWith(color: greenColor_Alpha, radius: length/2 - 10, viewWidth: length, finalPercent: 1.0, anmation: false, fromPercent: nil))
    }
    
    /// 创建一个圆圈Layer，但是还没有动画
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - radius: 半径
    ///   - viewWidth: 视图宽度
    ///   - percent: 百分strokeColor比
    /// - Returns: 返回一个CAShapeLayer
    private func circleLayerWith(color: CGColor, radius: CGFloat, viewWidth: CGFloat, finalPercent: CGFloat, anmation: Bool, fromPercent: CGFloat?) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = viewWidth/7
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        layer.strokeColor = color
        if anmation { layer.addColorAnimation(duration: 1.0, fromPercent: fromPercent, toPercent: finalPercent) }
        let p = finalPercent==0 ? 0.001 : finalPercent
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: viewWidth/2, y: viewWidth/2),
                                     radius: radius,
                                     startAngle: -CGFloat.pi*0.5,
                                     endAngle: CGFloat.pi*2*p - CGFloat.pi*0.5,
                                     clockwise: true)
        layer.path = path.cgPath
        return layer
    }
    
    public static func getColorFromPercent(percent: CGFloat) -> CGColor {
        
        let green = healthColor.1
        let blue = healthColor.2
        let cgRed = percent < 0.4 ? 1.0 : CGFloat(0.6)
        let color = UIColor.init(red: cgRed, green: CGFloat(green)*(percent+0.2)/255.0, blue: CGFloat(blue)*percent/255.0, alpha: CGFloat(healthColor.3)).cgColor
        
        return color
    }
    
    public func drawCircle(percent: CGFloat) -> CALayer {
        let length = self.frame.width
        let circleLayer = circleLayerWith(color: UIView.getColorFromPercent(percent: percent),
                                          radius: length/2 - 10,
                                          viewWidth: length,
                                          finalPercent: CGFloat(percent),
                                          anmation: true, fromPercent: nil)
        let shadowLayer = circleLayer.addCircleAnimation(duration: 1.0, from: 0, to: 1).addShadow() // CALayer
        self.layer.addSublayer(shadowLayer)
        return shadowLayer
    }
    
    public func updateCircle(layer: CALayer, from: CGFloat, to: CGFloat) -> CALayer {
        layer.removeFromSuperlayer()
        let length = self.frame.width
        let circleLayer = circleLayerWith(color: UIView.getColorFromPercent(percent: to), radius: length/2 - 10, viewWidth: length, finalPercent: CGFloat(to), anmation: true, fromPercent: CGFloat(from))
        let newFrom = from==0 ? 0.001 : from
        let shadowLayer = circleLayer.addCircleAnimation(duration: 1.0, from: CGFloat(newFrom), to: CGFloat(to)).addShadow()
        return shadowLayer
    }
}
