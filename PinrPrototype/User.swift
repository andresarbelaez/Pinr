//
//  User.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import Parse
import UIKit

class User: PFObject
{
    class func createUser(image : UIImage?, friends: [PFUser], bio: String?, displayName: String?, withCompletion completion: PFBooleanResultBlock?)
    {
        
        let user = PFObject(className: "User")
        user["bio"] = bio
        user["displayName"] = displayName
        user["profilePicture"] =  getPFFileFromImage(image: image) // PFFile column type
        user["friends"] = friends
        //user["activityLog"] = []
        user.saveInBackground(block: completion)
    }
    class func getPFFileFromImage(image: UIImage?) -> PFFile?
    {
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
