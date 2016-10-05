//
//  EventFeedVC.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/25/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class EventFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var events : [PFObject] = []
    var eventToBeDetailed: PFObject?
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadEvents()
        refreshControl.addTarget(self, action: #selector(EventFeedVC.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("check if here")
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = self.events[indexPath.row]
        cell.event = event
        print("cell event: ", event["name"])
        cell.goingButtonAction = { (EventCell) in
            print("button at row ", indexPath.row, " was tapped")
            ///important note
            //here, still need to add attendee to event list of attendees
            //also need to update user model, adding current event to list of
            //user events
            let parseEvent = cell.event
            let currentUser = PFUser.current()
            Attendance.createAttendance(event: parseEvent!, attendee: currentUser!, likers: [], commentors: [], comments: [], time: NSDate(), withCompletion: { (success: Bool, error: Error?) in
                
                if success {
                    print("success. attendance event sent to parse")
                } else {
                    print("error: ", error?.localizedDescription)
                }
            })
            
            cell.event?.add(currentUser!, forKey: "attending")
            /*
            cell.event?.saveInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    print("success. Added attendee to event")
                } else {
                    print("error adding attendee to event")
                }
            }) */
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        //let cell = tableview(tableView(UITableView, cellForRowAt: indexPath))
        let cell = tableView.cellForRow(at: indexPath)
        let event = events[indexPath.row]
        var vc: EventDetailVC
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        vc = storyboard.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
        vc.event = event
        vc.eventString = event["name"] as! String?
        print("at least this cell is being selected")
        self.eventToBeDetailed = event
        print("1. performSegue function is called, eventToBeDetailed updated")
        performSegue(withIdentifier: "eventDetailSegue", sender: cell)
        /*
        var navigationArray: [UIViewController] = (self.navigationController?.viewControllers)!
        navigationArray.append(vc)
        self.navigationController!.viewControllers = navigationArray
        self.navigationController?.pushViewController(vc, animated: true)
 */
        
        
    }
    
    func loadEvents(){
        let query = PFQuery(className: "Event")
        query.order(byDescending: "startDate")
        query.includeKey("username")
        query.includeKey("User")
        query.includeKey("_User")
        query.includeKey("attending")
        query.includeKey("username")
        query.includeKey("profilePicture")
        let currentDate: NSDate = NSDate()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.day = 1
        let maxDate: Date = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))!
        //query.whereKey("startDate", lessThan: maxDate)
        query.whereKey("endDate", greaterThan: currentDate)
        
        
        query.findObjectsInBackground { (events: [PFObject]?, error: Error?) in
            if error == nil {
                print("Here are the loaded events: ")
                if let events = events {
                    self.events = events
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    for event in self.events {
                        print("EVENT: ", event["name"])
                    }
                }
            } else {
                print("error querying events")
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadEvents()
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailSegue" {
            let vc = segue.destination as! EventDetailVC
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let event = events[(indexPath?.row)!]
            vc.event = event
            //vc.event = eventToBeDetailed
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
