//
//  CustomMarkerData.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/29/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import Foundation
import Parse

class customMarkerData {
    var event: PFObject?
    var name: String?
    var location: String?
    var description: String?
    var startTime: String?
    var endTime: String?
    var timeToShow: String?
    var type: String?
    var imageData: Data?
    init(event: PFObject) {
        self.event = event
        if let eventName = event["name"] as? String {
            self.name = eventName
        } else {
            print("error getting name in customMarkerData")
        }
        if let eventLocation = event["locationName"] as? String {
            self.location = eventLocation
        } else {
            print("error getting locationName in customMarkerData")
        }
        if let eventDescription = event["description"] as? String {
            self.description = eventDescription
        }
        if let eventType = event["privacy"] as? Bool {
            if eventType {
                self.type = "Event Type: Public"
            } else {
                self.type = "Event Type: Private"
            }
        }
        
        if let end = event["endDate"] as? NSDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            self.timeToShow = ("ends in " + DateExtension.getTimeBetween(a: Date(), b: end as Date))
            //self.timeToShow = "ending at " + dateFormatter.string(from: end as Date)
        }
        
        if let start = event["startDate"] as? NSDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            if start.timeIntervalSinceNow > 0 {
                self.timeToShow = "starts in " + DateExtension.getTimeBetween(a: Date(), b: start as Date)
                //self.timeToShow = "starting at" + dateFormatter.string(from: start as Date)
            }
        } else {
            print("lalalalalala")
        }
        
        
        if let parseImage = event.value(forKey: "picture")! as? PFFile
        {
            print("this should be the PFFile", parseImage, "for event: ", event["name"] as? String)
            parseImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error == nil){
                    print("got data for:", self.event?["name"] as! String)
                    self.imageData = data!
                } else {
                    print("couldn't get image data")
                    print(error?.localizedDescription)
                    self.imageData = Data()
                }
                
            })
        }
        
    }
    

}
