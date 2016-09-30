//
//  Event.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/24/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject {
    class func createEvent(image : UIImage?, locationCoordinates: [Double], locationName: String, privacy: Bool?, description: String?, name: String?, invited: [PFUser], attending: [PFUser], hosts: [PFUser], startDate: NSDate, endDate: NSDate, withCompletion completion: PFBooleanResultBlock?) {
        
        let event = PFObject(className: "Event")
        event["description"] = description
        event["name"] = name
        event["picture"] =  getPFFileFromImage(image: image) // PFFile column type
        event["locationCoordinates"] = locationCoordinates
        event["locationName"] = locationName
        event["privacy"] = privacy
        event["invited"] = invited
        event["attending"] = attending
        event["hosts"] = hosts
        event["startDate"] = startDate
        event["endDate"] = endDate
        event.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
