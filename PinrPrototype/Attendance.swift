//
//  Attendance.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/24/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class Attendance: PFObject {
    class func createAttendance(event : PFObject, attendee: PFUser, likers: [PFUser], commentors: [PFUser],comments: [String], time: NSDate, withCompletion completion: PFBooleanResultBlock?) {
        
        let attendance = PFObject(className: "Attendance")
        
        attendance["event"] = event
        attendance["attendee"] = attendee
        attendance["likeCount"] = 0
        attendance["commentCount"] = 0
        attendance["likers"] = likers
        attendance["commentors"] = commentors
        attendance["comments"] = comments
        attendance["time"] = time
        attendance.saveInBackground(block: completion)
    }
}
