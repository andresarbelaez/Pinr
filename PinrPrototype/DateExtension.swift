//
//  DateExtension.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 10/3/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit

class DateExtension {
    private static var yearLength: Double = 31540000.0
    private static var monthLength: Double = 2628000.0
    private static var weekLength: Double = 604800.0
    private static var dayLength: Double = 86400.0
    private static var hourLength: Double = 3600.0
    private static var minuteLength: Double = 60.0
    
    class func getTimeBetween(a: Date, b: Date) -> String{
        var secondsBetween: Double
        if a.timeIntervalSince(b) > 0 {
            secondsBetween = a.timeIntervalSince(b) as Double
        } else {
            secondsBetween = b.timeIntervalSince(a) as Double
        }
        if secondsBetween > yearLength {
            let years = secondsBetween/yearLength
            let yearsInt = Int(years)
            return "\(yearsInt)y"
        } else if secondsBetween > monthLength {
            let months = secondsBetween/monthLength
            let monthsInt = Int(months)
            return "\(monthsInt)mo"
        } else if secondsBetween > weekLength {
            let weeks = secondsBetween/weekLength
            let weeksInt = Int(weeks)
            return "\(weeksInt)w"
        } else if secondsBetween > dayLength {
            let days = secondsBetween/dayLength
            let daysInt = Int(days)
            return "\(daysInt)d"
        } else if secondsBetween > hourLength {
            let hours = secondsBetween/hourLength
            let hoursInt = Int(hours)
            return "\(hoursInt)h"
        } else if secondsBetween > minuteLength {
            let minutes = secondsBetween/minuteLength
            let minutesInt = Int(minutes)
            return "\(minutesInt)m"
        } else {
            return "a few seconds ago"
        }
        return ""
    }
}
