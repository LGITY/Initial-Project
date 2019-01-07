//
//  Home.swift
//  Login-Screen
//
//  Created by Davis Booth on 11/24/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CoreLocation

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    

    @IBOutlet weak var mainTableView: UITableView!
    
    var ref: DatabaseReference?
    var transitionInfo: String?
    let manager = CLLocationManager()
    
    // Data array from server.
    var availablePosts: [String: Any] = [:] {
        didSet {
            mainTableView.reloadData()
            let sorted = availablePosts.keys.sorted { (key1, key2) -> Bool in
                let t1 = (availablePosts[key1] as! [String : Any])["time"] as! String
                let t2 = (availablePosts[key2] as! [String : Any])["time"] as! String
                return t1 < t2
            }
            availablePostKeys = sorted
        }
    }
    
    // Specifically keys for data array.
    var availablePostKeys: [String] = [String]() {
        didSet {
            mainTableView.reloadData()
            print(availablePostKeys)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        ref = Database.database().reference()
        
        // Update location. --- TODO: Make this this real deadass location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = kCLDistanceFilterNone
        if let loc = manager.location {
            let fullThing = loc.coordinate.latitude.description + " " + loc.coordinate.longitude.description
            //self.ref?.child("Users").child(SignUp1.User.uid).child("location").setValue(fullThing)
        }
        
        // Creates nibs.
        let nibName = UINib(nibName: "HomePostCell", bundle: nil)
        let nibName2 = UINib(nibName: "inMyAreaCell", bundle: nil)
        
        // Registers nibs.
        mainTableView.register(nibName, forCellReuseIdentifier: "HomePostCell")
        mainTableView.register(nibName2, forCellReuseIdentifier: "inMyAreaCell")
        
        // Disables scrollbars.
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.showsVerticalScrollIndicator = false
        
        // Sets background color to match separator color.
        //mainTableView.backgroundColor = UIColor(red:0.33, green:0.34, blue:0.36, alpha:1)
        //mainTableView.sectionIndexBackgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        // Observes available events.
        ref?.child("Users").child(SignUp1.User.uid).child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: String]
            var tempArr: [String: Any] = [:]
            if let value2 = value {
                for event in value2.keys {
                    self.ref?.child("Events").child(event).observeSingleEvent(of: .value, with: { (snapshot) in
                        let val = snapshot.value as! [String: Any]
                        self.availablePosts[event] = val    // Needs some work -- use the dispatch thing like Clayton
                    })
                }
            }
            //self.availablePosts = tempArr
            
            // I was about to change this so that we just grabbed the list of event ids from the user and then
            // went to the actual events node of the database to grab the event information
        })
        

    }
    
    // Allows In My Area cells to segue.
    func syntheticPerform(_ t: String) {
        // Allows for access to t by prepare().
        self.transitionInfo = t
        self.performSegue(withIdentifier: "toGeo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGeo" {
            let dest = segue.destination as! GeoSport
            dest.sport = transitionInfo!
        }
        if segue.identifier == "toComments" {
            let dest = segue.destination as! CommentsView
            dest.eid = transitionInfo
        }
    }
    
    
    @IBAction func moreTab(_ sender: Any) {
        print("Toggle More Tab")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleMoreTab"), object: nil)
        
    }
    
    
}




// Extension for TableViewDelegate.
extension Home {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "In My Area"
        }
        else {
            return "From My Friends"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return availablePostKeys.count
        }
    }
    
    // One section for In My Area. One for From my Friends.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 401
        }
        else {
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 && indexPath.section == 0 {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "inMyAreaCell", for: indexPath) as! inMyAreaCell
            
            // Giving the cell itself access to this instance of the Home controller. Allows segue later.
            cell.parentViewController = self
            return cell
        }
            
        else {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
            
            // The event id for this event.
            let eid = availablePostKeys[indexPath.item]
            print(availablePosts[eid] as! [String: Any])
            
            let comments = determineComments(eid)
            
            // This looks more complex than it is. Basically just retyping a couple times for each piece of data.
            cell.fullInit((availablePosts[eid] as! [String: Any])["host"] as! String , evID: eid, activity: (availablePosts[eid] as! [String: Any])["eventType"] as! String, eventName: (availablePosts[eid] as! [String: Any])["eventName"] as! String, numberParticipants: Int((availablePosts[eid] as! [String: Any])["numParticipants"] as! String)!, time: (availablePosts[eid] as! [String: Any])["time"] as! String, loc: (availablePosts[eid] as! [String: Any])["locationName"] as! String, numComments: comments, parentView: self, indexPath: indexPath)
            
            return cell
        }
    }
    
    func determineComments(_ eid: String) -> Int {
        
        if (availablePosts[eid] as! [String: Any]).keys.contains("comments") {
            return ((availablePosts[eid] as! [String: Any])["comments"] as! [String : Any]).count
        }
        return 0
    }
    
    

}
