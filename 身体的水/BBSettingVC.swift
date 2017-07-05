//
//  BBSettingVC.swift
//  身体的水
//
//  Created by Hancock on 2017/1/18.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications

class BBSettingVC: UITableViewController{
   
    @IBOutlet weak var BBlittleTextField: UITextField!
    
    @IBOutlet weak var genderValue: UISegmentedControl!
    @IBOutlet weak var BBcupTextField: UITextField!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshModel.sharedModel.refreshData()
        BBConnectDataModel.sharedModel.setSession()
        BBHealthKitManager.manager.authorization()
        layOutViewContent()
    }
    
    private func layOutViewContent() {
        if BBSettingDataModel.sharedModel.gender == true{
            genderValue.selectedSegmentIndex = 0
        }
        else {
            genderValue.selectedSegmentIndex = 1
        }
        BBlittleTextField.text = "\(BBSettingDataModel.sharedModel.littleDrink!)"
        BBcupTextField.text = "\(BBSettingDataModel.sharedModel.cupDrink!)"
        ageLabel.text = "\(BBSettingDataModel.sharedModel.age!)"
        heightLabel.text = "\(BBSettingDataModel.sharedModel.height!)cm"
        weightLabel.text = "\(BBSettingDataModel.sharedModel.weight!)kg"
    }
    
    @IBAction func genderchange(_ sender: Any) {
        let gender = sender as! UISegmentedControl
        if gender.selectedSegmentIndex == 0 {
            BBSettingDataModel.sharedModel.gender = true
        }
        else {
            BBSettingDataModel.sharedModel.gender = false
        }
    }

    @IBAction func subAge(_ sender: Any) {
        var age = BBSettingDataModel.sharedModel.age
        age = age! - 1
        ageLabel.text = "\(age!)"
        BBSettingDataModel.sharedModel.age = age
    }
    @IBAction func plusAge(_ sender: Any) {
        var age = BBSettingDataModel.sharedModel.age
        age = age! + 1
        ageLabel.text = "\(age!)"
        BBSettingDataModel.sharedModel.age = age
    }
    
    @IBAction func subHeight(_ sender: Any) {
        var height = BBSettingDataModel.sharedModel.height
        height = height! - 1
        heightLabel.text = "\(height!)cm"
        BBSettingDataModel.sharedModel.height = height
    }
    
    @IBAction func plusHeight(_ sender: Any) {
        var height = BBSettingDataModel.sharedModel.height
        height = height! + 1
        heightLabel.text = "\(height!)cm"
        BBSettingDataModel.sharedModel.height = height
    }
    
    @IBAction func subWeight(_ sender: Any) {
        var weight = BBSettingDataModel.sharedModel.weight
        weight = weight! - 1
        weightLabel.text = "\(weight!)kg"
        BBSettingDataModel.sharedModel.weight = weight
    }
    
    @IBAction func plusWeight(_ sender: Any) {
        var weight = BBSettingDataModel.sharedModel.weight
        weight = weight! + 1
        weightLabel.text = "\(weight!)kg"
        BBSettingDataModel.sharedModel.weight = weight
    }
    
    @IBAction func saveAction(_ sender: Any) {
        BBSettingDataModel.sharedModel.saveDataToUserDefalt()
        SVProgressHUD.showSuccess(withStatus: "保存成功")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableView.endEditing(false)
        let a = NSString.init(string: BBcupTextField.text!)
        BBSettingDataModel.sharedModel.cupDrink = Int(a.intValue)
        let b = NSString.init(string: BBlittleTextField.text!)
        BBSettingDataModel.sharedModel.littleDrink = Int(b.intValue)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let count = BBSettingDataModel.sharedModel.calculateWaterNum()
            BBConnectDataModel.sharedModel.saveWaterLeftData(value: count)
            SVProgressHUD.showInfo(withStatus: "今日应喝\(count)毫升水")
            BBSettingDataModel.sharedModel.saveDataToUserDefalt()
        }
        else if indexPath.section == 4 {
            BBConnectDataModel.sharedModel.updateData()
        }
    }

}
