//
//  ProfilePictureCollectionCell.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/30/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class ProfilePictureCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    var user: PFUser? {
        didSet {
            if let profilePicturePF = user?.value(forKey: "profilePicture") as? PFFile {
                profilePicturePF.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error == nil){
                        let image = UIImage(data: data!)
                        self.profilePicture.image = image
                        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width / 2
                        self.profilePicture.clipsToBounds = true
                        self.profilePicture.layer.borderWidth = 2
                        self.profilePicture.layer.borderColor = UIColor.darkGray.cgColor
                    } else {
                        print("couldn't get image data")
                        print(error?.localizedDescription)
                    }
                })
            }
        }
    }
}
