//
//  EventDetailVC.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/28/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class EventDetailVC: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPictureView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var event: PFObject?
    var eventString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.clipsToBounds = true
        eventPictureView.layer.borderWidth = 3
        eventPictureView.layer.borderColor = UIColor.darkGray.cgColor
        
        /* This button layouting should go in the layout view did layout subview method in the future */
        
        print("in the event details VC", eventString)
        if let eventName = event?["name"] as? String{
            self.eventNameLabel.text = eventName
        } else {
            print("error getting name in detailView")
        }
        if let eventLocation = event?["locationName"] as? String {
            self.eventLocationLabel.text = eventLocation
        } else {
            print("error getting locationName in detailview")
        }
        if let eventDescription = event?["description"] as? String {
            self.eventDescriptionLabel.text = eventDescription
        }
        if let eventType = event?["privacy"] as? Bool {
            if eventType {
                self.eventTypeLabel.text = "Event Type: Public"
            } else {
                self.eventTypeLabel.text = "Event Type: Private"
            }
        }
        
        if let parseImage = event?.value(forKey: "picture")! as? PFFile
        {
            print("this should be the PFFile", parseImage, "for event: ", event?["name"] as? String)
            parseImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                if (error == nil){
                    print("got data for:", self.event?["name"] as! String)
                    let image = UIImage(data: data!)
                    self.eventPictureView.image = image
                    self.eventPictureView.layer.cornerRadius = self.eventPictureView.frame.width / 2
                    self.eventPictureView.clipsToBounds = true
                } else {
                    print("couldn't get image data")
                    print(error?.localizedDescription)
                }
                
            })
        }

        
        // Do any additional setup after loading the view.
    }
    @IBAction func onDismissButton(_ sender: AnyObject) {
        dismiss(animated: true) { 
            print("dismissing event detail view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
