//
//  FeedViewController.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/23/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var attendances: [PFObject] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func loadData(){
        let query = PFQuery(className: "Attendance")
        query.includeKey("event")
        query.includeKey("attendee")
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
    
    @IBAction func eventNameTap(_ sender: AnyObject) {
        performSegue(withIdentifier: "eventSegue", sender: sender as! UIButton)
        print("THIS IS HAPPENING RIGHT NOW")
        print("\(sender.tag)")
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
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
