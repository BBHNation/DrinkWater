//
//  BBNoticeSettingVC.swift
//  身体的水
//
//  Created by Hancock on 2017/1/19.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications

enum ViewTypeToShow{
    case BEGIN
    case END
    case FRE
    case NOTHING
}

class BBNoticeSettingVC: UITableViewController {
    let viewHeight : CGFloat = 250.0
    var beginTimePicker : BBBeginTimePicker?
    var endTimePicker : BBEndTimePicker?
    var frequencyTimePicker : BBFrequencyTimePicker?
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        let switchOn = userDefaults?.bool(forKey: NOTICE_SWITCH_ON)
        noticeSwitch.isOn = switchOn!
       
        addViews()
    }
    
    @IBAction func noticeSwitchChange(_ sender: Any) {
        if noticeSwitch.isOn == true {
            //添加通知
            if #available(iOS 8.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = UIApplication.shared.delegate as! UNUserNotificationCenterDelegate?
                center.requestAuthorization(options: [UNAuthorizationOptions.alert,.badge,.sound], completionHandler: { (isCompletion, error) in
                })
            }
            addNotice()
        }
        else {
            BBNotificationModel.sharedModel.removeAllNotice()
        }
        let userDefaults = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        userDefaults?.set(noticeSwitch.isOn, forKey: NOTICE_SWITCH_ON)
        userDefaults?.synchronize()
    }
    @IBAction func beginSure(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
        //设置时间
        beginTimeLabel.text = dateToHour(date: (beginTimePicker?.datePicker.date)!)
    }
    @IBAction func beginCancle(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
    }
    
    @IBAction func endSure(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
        //设置时间
        endTimeLabel.text = dateToHour(date: (endTimePicker?.datePicker.date)!)
    }
    
    @IBAction func endCacle(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
    }
    @IBAction func frequencyCancel(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
    }
    
    @IBAction func frequencySure(_ sender: Any) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
        //设置时间
        frequencyLabel.text = dateToFrequency(date: (frequencyTimePicker?.datePicker.date)!)
    }
    
    private func dateToFrequency(date : Date) -> String {
        let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let com = calender?.components([NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: date)
        if com?.hour == 0 {
            return "\((com?.minute)!)分钟／次"
        }
        return "\(com!.hour!)小时\((com?.minute)!)分钟／次"
    }
    
    
    /// 将date转换为String
    private func dateToHour(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: date)
    }
    
    /// 将date转换为相应的 小时.分钟 的Double值
    private func dateToHour(date : Date) -> Double{
        let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let component = calender?.components([NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: date)
        let minuteDouble = Double((component?.minute)!)/60
        let hourDouble = Double((component?.hour)!)
        let final = hourDouble+minuteDouble
        return final
    }
    private func frequencyToTimeInterval(date : Date) -> TimeInterval{
        let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let com = calender?.components([NSCalendar.Unit.second, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: date)
        let intervalInt = (com?.hour)! * 3600 + (com?.minute)! * 60
        return TimeInterval.init(intervalInt)
    }
    
    private func addViews() {
        beginTimePicker = Bundle.main.loadNibNamed("BBBeginTimePicker", owner: self, options: nil)?.first as? BBBeginTimePicker
        beginTimePicker?.frame = CGRect(x: 0.0, y:self.view.bounds.size.height, width: UIScreen.main.bounds.size.width, height: viewHeight)
        UIApplication.shared.keyWindow?.addSubview(beginTimePicker!)
        
        endTimePicker = Bundle.main.loadNibNamed("BBEndTimePicker", owner: self, options: nil)?.first as? BBEndTimePicker
        endTimePicker?.frame = CGRect(x: 0, y:self.view.bounds.size.height, width: UIScreen.main.bounds.size.width, height: viewHeight)
        UIApplication.shared.keyWindow?.addSubview(endTimePicker!)
 
        frequencyTimePicker = Bundle.main.loadNibNamed("BBFrequencyTimePicker", owner: self, options: nil)?.first as? BBFrequencyTimePicker
        frequencyTimePicker?.frame = CGRect(x: 0, y:self.view.bounds.size.height, width: UIScreen.main.bounds.size.width, height: viewHeight)
        UIApplication.shared.keyWindow?.addSubview(frequencyTimePicker!)
        
        getDate()
        
        beginTimeLabel.text = dateToHour(date: (beginTimePicker?.datePicker.date)!)
        frequencyLabel.text = dateToFrequency(date: (frequencyTimePicker?.datePicker.date)!)
        endTimeLabel.text = dateToHour(date: (endTimePicker?.datePicker.date)!)
    }
    
    private func showViewWithType(type : ViewTypeToShow) {
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            if let strongSelf = self {
                strongSelf.beginTimePicker?.transform = CGAffineTransform.identity
                strongSelf.endTimePicker?.transform = CGAffineTransform.identity
                strongSelf.frequencyTimePicker?.transform = CGAffineTransform.identity
            }
        })
        
        if type == ViewTypeToShow.NOTHING {
            return
        }
        else if type == ViewTypeToShow.BEGIN {
            UIView.animate(withDuration: 0.5, animations: {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.beginTimePicker?.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf.viewHeight)
                }
            })
        }
        else if type == ViewTypeToShow.END {
            UIView.animate(withDuration: 0.5, animations: {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.endTimePicker?.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf.viewHeight)
                }
            })
        }
        else if type == ViewTypeToShow.FRE {
            UIView.animate(withDuration: 0.5, animations: {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.frequencyTimePicker?.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf.viewHeight)
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showViewWithType(type: ViewTypeToShow.NOTHING)
    }
    
    private func getDate() {
        let userDefault = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        let beginDate = userDefault?.object(forKey: "beginTimeDate") as? Date
        if beginDate != nil {
            beginTimePicker?.datePicker.date = beginDate!
        }
        
        let endDate = userDefault?.object(forKey: "endTimeDate") as? Date
        if endDate != nil {
            endTimePicker?.datePicker.date = endDate!
        }
        
        let freDate = userDefault?.object(forKey: "freTimeDate") as? Date
        if freDate != nil {
            frequencyTimePicker?.datePicker.date = freDate!
        }
    }
    
    private func saveDate() {
        let userDefault = UserDefaults.init(suiteName: SHARED_USER_DEFAULT)
        userDefault?.setValue(beginTimePicker?.datePicker.date, forKey: "beginTimeDate")
        userDefault?.setValue(endTimePicker?.datePicker.date, forKey: "endTimeDate")
        userDefault?.setValue(frequencyTimePicker?.datePicker.date, forKey: "freTimeDate")
        userDefault?.synchronize()
    }
    
    private func addNotice() {
        let beginInt : Double = dateToHour(date: (beginTimePicker?.datePicker.date)!)
        let endInt : Double = dateToHour(date: (endTimePicker?.datePicker.date)!)
        let freInterval = frequencyToTimeInterval(date: (frequencyTimePicker?.datePicker.date)!)
        BBNotificationModel.sharedModel.addNotification(beginTime: beginInt, endTime: endInt, frequencyInterval: freInterval)
        SVProgressHUD.show(withStatus: "保存中")
        SVProgressHUD.showSuccess(withStatus: "保存成功")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                showViewWithType(type: ViewTypeToShow.BEGIN)
            }else if indexPath.row == 1 {
                showViewWithType(type: ViewTypeToShow.END)
            }
        }
        else if indexPath.section == 2 {
            showViewWithType(type: ViewTypeToShow.FRE)
        }
        else {
            showViewWithType(type: ViewTypeToShow.NOTHING)
            //这里做保存和发通知
            addNotice()
            saveDate()
        }
    }

}
