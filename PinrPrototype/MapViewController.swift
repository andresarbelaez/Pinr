//
//  MapViewController.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import Parse

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var placesClient: GMSPlacesClient?
    var placePicker: GMSPlacePicker?
    let infoMarker = GMSMarker()
    let locationManager = CLLocationManager()
    let geocoder: GMSGeocoder? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        loadData()
    }
    
    func loadData(){
        mapView.clear()
        let query = PFQuery(className: "Event")
        query.includeKey("username")
        let currentDate: NSDate = NSDate()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.day = 1
        let maxDate: Date = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))!
        query.whereKey("startDate", lessThan: maxDate)
        query.whereKey("endDate", greaterThan: currentDate)
        query.includeKey("User")
        query.includeKey("_User")
        query.includeKey("attending")
        query.includeKey("username")
        query.includeKey("profilePicture")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if error == nil {
                print("Here are the events: ")
                if let events = events {
                    for event in events {
                        let location = event["locationCoordinates"] as! [Double]
                        let locationCoordinates = CLLocationCoordinate2DMake(location[0] , location[1])
                        let eventMarker = GMSMarker()
                        let customData = customMarkerData(event: event)
                        eventMarker.userData = customData
                        eventMarker.title = event["name"] as! String?
                        eventMarker.icon = UIImage(named: "blackLogo.png")
                        eventMarker.position = locationCoordinates
                        self.getAddress(coordinate: locationCoordinates, completion: { (address) in
                            if let locationName = event["locationName"] as? String {
                                if locationName == "" {
                                    print("address should be: ", address)
                                    eventMarker.snippet = address
                                } else {
                                    eventMarker.snippet = locationName + ": " + address
                                }
                            }
                            
                        })
                    
                        eventMarker.map = self.mapView
                        eventMarker.icon = UIImage(named: "blueLogo.png")
                        
                    }
                }
            } else {
                print("error querying events")
            }
        }
    }
    
    func loadTomorrowData(){
        mapView.clear()
        let query = PFQuery(className: "Event")
        query.includeKey("username")
        let currentDate: NSDate = NSDate()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.day = 1
        let minDate: Date = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))!
        components.day = 2
        let maxDate: Date = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))!
        query.whereKey("startDate", lessThan: maxDate)
        query.whereKey("endDate", greaterThan: minDate)
        query.includeKey("User")
        query.includeKey("_User")
        query.includeKey("attending")
        query.includeKey("username")
        query.includeKey("profilePicture")
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if error == nil {
                print("Here are tomorrow's events: ")
                if let events = events {
                    for event in events {
                        let location = event["locationCoordinates"] as! [Double]
                        let locationCoordinates = CLLocationCoordinate2DMake(location[0] , location[1])
                        let eventMarker = GMSMarker()
                        let customData = customMarkerData(event: event)
                        eventMarker.userData = customData
                        eventMarker.title = event["name"] as! String?
                        eventMarker.icon = UIImage(named: "blackLogo.png")
                        eventMarker.position = locationCoordinates
                        self.getAddress(coordinate: locationCoordinates, completion: { (address) in
                            if let locationName = event["locationName"] as? String {
                                if locationName == "" {
                                    print("address should be: ", address)
                                    eventMarker.snippet = address
                                } else {
                                    eventMarker.snippet = locationName + ": " + address
                                }
                            }
                            
                        })
                        
                        eventMarker.map = self.mapView
                        eventMarker.icon = UIImage(named: "blueLogo.png")
                        
                    }
                }
            } else {
                print("error querying events")
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        /*
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "logoSmall.png")
 
        marker.map = self.mapView
        self.mapView.camera = camera
 
 */
        locationManager.startUpdatingLocation()
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        loadData()
        /*
        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
        let london = GMSMarker(position: position)
        london.title = "London"
        london.icon = UIImage(named: "logo")
        london.map = mapView
        */
        
    }
    @IBAction func onLoadTomorrow(_ sender: AnyObject) {
        loadTomorrowData()
    }
    @IBAction func onLoadToday(_ sender: AnyObject) {
        loadData()
    }
    
    @IBAction func getCurrentPlace(_ sender: AnyObject) {
        
        placesClient?.currentPlace(callback: { (placeLikelihoodList: GMSPlaceLikelihoodList?, error: Error?) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n")
                }
            }
        })
    }
        // Attach an info window to the POI using the GMSMarker.
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        self.mapView.selectedMarker = infoMarker
    }
    
    
    //Customizes the infoMarker of each respective marker.
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = Bundle.main.loadNibNamed("EventMarkerView", owner: self, options: nil)?.first as! CustomInfoWindow
        
        //customInfoWindow.hostLabel.text =
        let markerData = marker.userData as! customMarkerData
        let imageData = markerData.imageData
        customInfoWindow.nameLabel.text = markerData.name
        customInfoWindow.dateLabel.text = markerData.timeToShow
        customInfoWindow.eventPictureView.image = UIImage(data: imageData!)
        
        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //let markerData = marker.userData as! customMarkerData
        performSegue(withIdentifier: "toEventSegue", sender: marker)
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        reverseGeocodeCoordinate(coordinate: cameraPosition.target)
        
        /*
        let handler = { (response: GMSReverseGeocodeResponse?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = mapView
            }
        }
        geocoder?.reverseGeocodeCoordinate(cameraPosition.target, completionHandler: handler as! GMSReverseGeocodeCallback)
        */
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let lines = address.lines as [String]!
                //self.addressLabel.text = lines?.joined(separator: "\n")
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventSegue" {
            let vc = segue.destination as! EventDetailVC
            let marker = sender as! GMSMarker
            let markerData = marker.userData as! customMarkerData
            let event = markerData.event
            vc.event = event
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("current location")
            print("latitude:", location.coordinate.latitude)
            print("longitude:", location.coordinate.longitude)
            //self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            self.mapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        }
        
    }
}





