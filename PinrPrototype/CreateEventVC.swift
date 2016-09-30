//
//  CreateEventVC.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse
import GooglePlacePicker
import GooglePlaces

class CreateEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, dateDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    var placePicker: GMSPlacePicker?
    var placesClient: GMSPlacesClient?
    
    
    
    
    var location: [Double]  = [0.0, 0.0]
    var locationName: String = ""
    var privacy: Bool = false
    var invited: [PFUser] = []
    var hosts: [PFUser] = [PFUser.current()!]
    var attending: [PFUser] = [PFUser.current()!]
    var startDate: NSDate? = NSDate()
    var endDate: NSDate? = NSDate()
    var image: UIImage = UIImage(named: "logo")!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        locationManager.startUpdatingLocation()
        //locationManager.location?.coordinate
        print("current location")
        print("in this method")
        if let currentLocation = locationManager.location {
            //print(currentLocation.coordinate.latitude)
            print("latitude:", currentLocation.coordinate.latitude)
            print("longitude:", currentLocation.coordinate.longitude)
            let latitude = (currentLocation.coordinate.latitude)
            let longitude = (currentLocation.coordinate.longitude)
            self.location[0] = latitude
            self.location[1] = longitude
            print("locationnnnn: ", self.location)
        }
        
        
        eventPic.layer.cornerRadius = self.eventPic.frame.size.width / 2
        eventPic.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddPicture(_ sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func onCreate(_ sender: AnyObject) {
        Event.createEvent(image: image, locationCoordinates: location, locationName: locationName, privacy: privacy, description: descriptionTextView.text, name: nameField.text, invited: invited, attending: attending, hosts: hosts, startDate: startDate!, endDate: endDate!) { (Bool, Error) in
            
            if Bool {
                print("succes. sent to Parse")
                //important note: need to figure out a way to add created event to list of events that host created.
                //PFUser.current()?.setObject(<#T##object: Any##Any#>, forKey: <#T##String#>)
                self.dismiss(animated: true){
                    
                }
            } else {
                print("not sent to Parse for some reason")
                print(Error?.localizedDescription)
            }
        }
    }
    
    @IBAction func pickPlace(_ sender: AnyObject) {
        let center = CLLocationCoordinate2DMake(37.788204, -122.411937)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlace(callback: { (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.locationNameLabel.text = place.name
                self.locationName = place.name
                self.locationAddressLabel.text = place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n")
                print("latitude:", place.coordinate.latitude)
                print("longitude:", place.coordinate.longitude)
                let latitude = (place.coordinate.latitude)
                let longitude = (place.coordinate.longitude)
                self.location[0] = latitude
                self.location[1] = longitude
            } else {
                self.locationNameLabel.text = "No place selected"
                self.locationAddressLabel.text = ""
            }
        })
    }
    
    @IBAction func getCurrentPlace(_ sender: AnyObject) {
        placesClient?.currentPlace(callback: { (placeLikelihoodList: GMSPlaceLikelihoodList?, error: Error?) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.locationNameLabel.text = "No current place"
            self.locationAddressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.locationNameLabel.text = place.name
                    self.locationName = place.name
                    self.locationAddressLabel.text = place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n")
                    print("latitude:", place.coordinate.latitude)
                    print("longitude:", place.coordinate.longitude)
                    let latitude = (place.coordinate.latitude)
                    let longitude = (place.coordinate.longitude)
                    self.location[0] = latitude
                    self.location[1] = longitude
                }
            }
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        image = editedImage
        eventPic.image = image
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)

    }
    
    
    func dateDismissed(startDate: Date?, endDate: Date?) {
        print("this method is running")
        self.startDate = startDate as NSDate?
        self.endDate = endDate as NSDate?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var strDate = dateFormatter.string(from: startDate!)
        startDateLabel.text = strDate
        var strDate2 = dateFormatter.string(from: endDate!)
        endDateLabel.text = strDate2
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue" {
            let dateVC = segue.destination as! DatePickerVC
            dateVC.delegate = self
            //dateVC.startDateLabel.text = "TESTING"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

// MARK: - CLLocationManagerDelegate
extension CreateEventVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
        }
        
    }
}






