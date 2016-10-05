//
//  SettingsViewController.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePicView: UIImageView!
    
    var attendances: [PFObject] = []
    let refreshControl = UIRefreshControl()
    var userToShow = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userToShow = PFUser.current()
        loadData()
        loadUserInfo()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceCell
        let attendance = self.attendances[indexPath.row]
        cell.eventButton.tag = indexPath.row
        cell.attendance = attendance
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.count
    }
    
    func loadUserInfo(){
        //if let person = userToShow as? PFUser {
            let profileName = userToShow?.username
            profileNameLabel.text = profileName
            if let parseImage = userToShow?.value(forKeyPath: "profilePicture") as? PFFile {
                parseImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if (error == nil){
                        self.profilePicView.image = UIImage(data: data!)
                        self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width / 2
                        self.profilePicView.clipsToBounds = true
                        self.profilePicView.layer.borderColor = UIColor.darkGray.cgColor
                        self.profilePicView.layer.borderWidth = 3
                    } else {
                        print("couldn't get image data")
                        print(error?.localizedDescription)
                    }
                    
                })
            }
        //}
        
    }
    
    func loadData(){
        let query = PFQuery(className: "Attendance")
        //query.whereKey("attendee", equalTo: userToShow?.username)
        query.includeKey("event")
        query.includeKey("attendee")
        query.includeKey("User")
        query.includeKey("_User")
        query.includeKey("attending")
        query.includeKey("username")
        query.includeKey("profilePicture")
        query.findObjectsInBackground { (attendances: [PFObject]?, error: Error?) in
            if error == nil {
                print("Here are the loaded attendances: ")
                if let attendances = attendances {
                    /*
                     do {
                     try (attendances.objectForKey("post") as! PFObject).fetchIfNeeded()
                     } catch _ {
                     print("There was an error")
                     }
                     */
                    self.attendances = attendances
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    for attendance in self.attendances {
                        print("attendee: ", attendance["attendee"])
                    }
                }
            } else {
                print("error querying attendances")
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        PFUser.logOutInBackground { (Error) in
            // PFUser.currentUser() will now be nil
            print("user has logged out")
            self.performSegue(withIdentifier: "backToLogin", sender: nil)
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
    }
    
    @IBAction func onEventTap(_ sender: AnyObject) {
        performSegue(withIdentifier: "profileToEventSegue", sender: sender as! UIButton)
        print("THIS IS HAPPENING RIGHT NOW")
        print("\(sender.tag)")
    }
    
    @IBAction func onEditPicture(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.profilePicView.image = editedImage
        let userProfile = userToShow
        userProfile?["profilePicture"] = Event.getPFFileFromImage(image: editedImage)
        userProfile?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("success. user profile picture updated")
            } else {
                print("failure. user profile picture not updated for this reason: ", error?.localizedDescription)
            }
        })
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToEventSegue" {
            let vc = segue.destination as! EventDetailVC
            let button = sender as! UIButton
            let attendanceInstance = attendances[button.tag]
            let eventt = attendanceInstance["event"] as! PFObject
            let id = attendanceInstance.objectId
            let query = PFQuery(className: "Attendance")
            query.whereKey("event", equalTo: eventt)
            query.includeKey("username")
            query.includeKey("User")
            query.includeKey("_User")
            query.findObjectsInBackground(block: { (attendanceResults: [PFObject]?, error: Error?) in
                if error == nil {
                    let attendanceInQuestion = attendanceResults?.first
                    let event = attendanceInQuestion?.object(forKey: "event") as! PFObject
                    self.fetch(object: event)
                    vc.event = event
                    vc.viewDidLoad()
                    let eventName = event["name"] as? String
                    let otherEventName = vc.event?["name"] as? String
                    print("eventName is this: ", eventName)
                    print("otherEventName is this: ", otherEventName)
                } else {
                    print("error querying one attendance")
                }
            })
            
            
            
        }
    }
    
    func fetch(object: PFObject) {
        do {
            try object.fetchIfNeeded()
        } catch {
            print(error)
        }
    }
}
