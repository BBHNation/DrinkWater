//
//  ComplicationController.swift
//  身体的水 WatchKit Extension
//
//  Created by Hancock on 2017/1/18.
//  Copyright © 2017年 Binhan Bai. All rights reserved.
//

import ClockKit
import WatchKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Timeline Configuration
    var oldNum: Int? = nil
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    func requestedUpdateDidBegin() {
        BBHealthKitManager.manager.getTotalDrinkCount { [weak self] (drinked, err) in
            guard let strongSelf = self else { return }
            if err != nil { return }
            let left = calculateWaterNum() - Int(drinked)
            if strongSelf.oldNum == nil || strongSelf.oldNum != left {
                let server=CLKComplicationServer.sharedInstance()
                for comp in (server.activeComplications)! {
                    server.reloadTimeline(for: comp)
                }
            }
        }
    }
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        let date = Date()
        let timeInterval = TimeInterval.init(60)
        let nextDate = Date.init(timeInterval: timeInterval, since: date)
        handler(nextDate)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        BBHealthKitManager.manager.getTotalDrinkCount(completion: { (drinked, err) in
            if err != nil { return }
            let left = calculateWaterNum() - Int(drinked)
            
            // Create the template and timeline entry.
            if complication.family == .modularSmall {
                let longText = left > 0 ? "\(left)" : "+\(abs(left))"
                let shortText = left > 0 ? "\(left)" : "+\(abs(left))"
                
                let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
                textTemplate.textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
                
                entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: textTemplate)
            }
            else if complication.family == .utilitarianSmall{
                let longText = left > 0 ? "\(left)" : "+\(abs(left))"
                let shortText = left > 0 ? "\(left)" : "+\(abs(left))"
                
                let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
                textTemplate.textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
                let image = UIImage(named: "water")
                textTemplate.imageProvider = CLKImageProvider(onePieceImage:image!)
                
                entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: textTemplate)
            }
            handler(entry)
        })
        
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
