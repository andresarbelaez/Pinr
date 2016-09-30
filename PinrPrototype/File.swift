//
//  File.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/25/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import Foundation

extension NSDate {
    class func timeAgoSinceDate(date: NSDate, numericDates:Bool) -> String
    {
        /*
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendar.Unit.Minute , NSCalendar.Unit.Hour , NSCalendar.Unit.Day , NSCalendar.Unit.WeekOfYear , NSCalendar.Unit.Month , NSCalendar.Unit.Year , NSCalendar.Unit.Second], fromDate: earliest, toDate: latest, options: NSCalendar.Options())
        
        if (components.year >= 2) {
            return "\(components.year) y"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) m"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) w"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 w"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) d"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 d"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) h"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 h"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) m"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 m"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) s"
        } else
        {
            return "2 s"
        }
 */
        return ""
    }
}
