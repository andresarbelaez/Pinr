//
//  AttendanceCell.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class AttendanceCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventButton: UIButton!
    var attendance: PFObject? {
        didSet {
            var time: String = ""
            if let x = attendance!["_created_at"] as! NSDate!
            {
                let str = NSDate.timeAgoSinceDate(date: x, numericDates: true)
                time = str
                timeLabel.text = "0m"
            }
            if let person = attendance!["attendee"] as? PFUser{
                nameLabel.text = person.username
            }
            
            if let event = attendance?["event"] as? PFObject {
                eventButton.setTitle(event["name"] as? String, for: .normal)
                print("eventName should be:", event["name"] as? String)
            } else {
                print("not getting event")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picture.layer.cornerRadius = self.picture.frame.size.width / 2
        picture.clipsToBounds = true
        picture.image = UIImage(named: "home.png")
        picture.layer.borderWidth = 2
        picture.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
