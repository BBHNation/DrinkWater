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
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
//        let myDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        // Create the template and timeline entry.
        if complication.family == .modularSmall {
            let longText = "\(UserDefaults.standard.integer(forKey: LEFT_WATER_NUM))"
            let shortText = "\(UserDefaults.standard.integer(forKey: LEFT_WATER_NUM))"
            
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
            
            entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: textTemplate)
        }
        else if complication.family == .utilitarianSmall{
            let longText = "\(UserDefaults.standard.integer(forKey: LEFT_WATER_NUM))"
            let shortText = "\(UserDefaults.standard.integer(forKey: LEFT_WATER_NUM))"
            
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
            let image = UIImage(named: "water")
            textTemplate.imageProvider = CLKImageProvider(onePieceImage:image!)
            
            entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: textTemplate)
        }
        handler(entry)
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
