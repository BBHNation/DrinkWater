//
//  BBLocationAndWeatherManger.swift
//  身体的水
//
//  Created by 白彬涵 on 2017/7/7.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit
import CoreLocation

class BBLocationAndWeatherManger: NSObject, CLLocationManagerDelegate {
    
    static let manager = BBLocationAndWeatherManger()// 单例模式
    private let clmanager = CLLocationManager()// 位置manager
    private var gotLocationAction: ((_ place: CLPlacemark?, _ err: Error?)->())? = nil// 获取位置之后的操作
    
    
    
    
    /// 网络请求获取天气情况
    ///
    /// - Parameter complete: Block
    public func getCityAndWeatherInfo(_ complete: @escaping (_ cityName: String?, _ temperature: String?, _ describe: String?, _ code: String?,_ err: Error?) -> ()) {
        getCurrentLocation { (placeMark, err) in
            if err != nil {
                complete(nil, nil, nil, nil, err!)
                return
            }
            guard let cityName: String = placeMark?.addressDictionary?["City"] as? String else {
                let error: Error = NSError.init(domain: "不能获取城市名", code: 1024, userInfo: nil) as Error
                complete(nil,nil,nil, nil, error)
                return
            }
            let url: URL = URL.init(string: "https://api.seniverse.com/v3/weather/now.json?key=4DGW8W2I1Q&location=\(cityName)&language=zh-Hans&unit=c".urlEncode)!
            BBNetworkManager.manager.requestWith(way: .Get, url: url, parameters: nil, completeBlock: { (data, response, err) in
                do {
                    if data == nil { // 如果没有结果返回
                        let error: Error = NSError.init(domain: "没有结果返回", code: 1026, userInfo: nil) as Error
                        complete(nil, nil, nil, nil, error)
                        return
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]// 解析Json
                    if let resultArr = json["results"] {
                        let result = (resultArr as! [Any]).first
                        guard let resultNow = (result as! [String : Any])["now"] as? [String : Any] else {
                            let error: Error = NSError.init(domain: "解析结果错误", code: 1025, userInfo: nil) as Error
                            complete(nil, nil, nil, nil, error)
                            return
                        }
                        complete(cityName, resultNow["temperature"] as? String, resultNow["text"] as? String, resultNow["code"] as? String,nil)
                    }
                } catch {
                    let error: Error = NSError.init(domain: "解析Json结果错误", code: 1026, userInfo: nil) as Error
                    complete(nil, nil, nil, nil, error)
                }
            })
        }
    }
    
    
    /// 开始获取当前位置
    private func getCurrentLocation(action: @escaping (_ place: CLPlacemark?, _ err: Error?) -> ()) {
        clmanager.requestAlwaysAuthorization()
        clmanager.delegate = self
        clmanager.startUpdatingLocation()
        gotLocationAction = action
    }
    
    
    /// 获取位置的回调
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!) { [unowned self] (placeMarks, err) in
            if err != nil {
                self.gotLocationAction!(nil, err)
                return
            }
            let placeMark = placeMarks?.first
            self.gotLocationAction!(placeMark, nil)
            self.clmanager.stopUpdatingLocation()
        }
    }
}
