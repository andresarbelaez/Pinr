//
//  EventCell.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/25/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class EventCell: UITableViewCell, GMSMapViewDelegate {

    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let geocoder: GMSGeocoder? = nil
    
    var goingButtonAction: ((UITableViewCell) -> Void)?
    var event: PFObject? {
        didSet {
            if let parseImage = event?.value(forKey: "picture")! as? PFFile
            {
                print("this should be the PFFile", parseImage, "for event: ", event?["name"] as? String)
                parseImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error == nil){
                        print("got data for:", self.event?["name"] as! String)
                        let image = UIImage(data: data!)
                        self.eventPic.image = image
                        self.eventPic.layer.cornerRadius = self.eventPic.frame.width / 2
                        self.eventPic.clipsToBounds = true
                        self.eventPic.layer.borderWidth = 2
                        self.eventPic.layer.borderColor = UIColor.darkGray.cgColor
                    } else {
                        print("couldn't get image data")
                        print(error?.localizedDescription)
                    }

                })
            }
            
            nameLabel.text = event?["name"] as? String
            
            let location = event?["locationCoordinates"] as! [Double]
            
            let locationCoordinates = CLLocationCoordinate2DMake(location[0] , location[1])
            self.getAddress(coordinate: locationCoordinates, completion: { (address) in
                if let locationName = self.event?["locationName"] as? String {
                    if locationName == "" {
                        self.locationLabel.text = address
                    } else {
                        self.locationLabel.text = locationName
                    }
                }
                //self.locationLabel.text = address
            })
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func goingButtonTap(_ sender: AnyObject) {
        goingButtonAction?(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getAddress(coordinate: CLLocationCoordinate2D, completion: @escaping (_ result: String) -> ()) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let lines = address.lines as [String]!
                let thing = (lines?.joined(separator: "\n"))!
                completion(thing)
            }
        }
    }

}
