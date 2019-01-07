//
//  GeoSport.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class GeoSport: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    
    var sport: String?
    var ref: DatabaseReference?
    
    var eventDict: [[CLLocationDegrees]: [String: [String: Any]]] = [:]
    var eventToDisplay: [String: Any]?
    var eid: String?
    var transitionInfo : String?
    var locationCenter: MKPlacemark? = nil
    var eventType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sport)
        self.title = sport! + " in my Area"
        ref = Database.database().reference()
        
        mapView.delegate = self
        tableView.layer.cornerRadius = 10
        locationManager.delegate = self  //sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //sets the accuracy of location to best possible accuracy
        locationManager.requestWhenInUseAuthorization()  //makes sure to seek user auth
        locationManager.requestLocation()  //requests the location of the user
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        let nibName = UINib(nibName: "HomePostCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "HomePostCell")
        tableView.isHidden = true
        
        ref?.child("Public Events").child(self.sport!).observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as? [String: [String: Any]]
            if let value = val {
                
                for game in value.keys {
                    let coordString = value[game]!["location"] as! String
                    let coordArr = coordString.split(separator: " ")
                    let eName = value[game]!["eventName"] as! String
                    // TODO :: Check if it is within the radius of the user
                    if self.geofence(loc : coordString) < 5.0 {
                        var eid: [String : [String : Any] ] = [:]
                        eid[game] = value[game]!
                        self.addPin([Double(coordArr[0])!, Double(coordArr[1])!], eventName: eName, eID: eid)
                    }
                }
            }
        })
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.hideTable(_:) ))
        mapView.addGestureRecognizer(gest)
    }
    
    @objc func hideTable(_ sender : Any) {
        if !tableView.isHidden {
            setView(view: tableView, hidden: true)
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseOut, animations: {
            view.isHidden = hidden
        })
    }
    
    func addPin(_ coordinates: [Double], eventName: String, eID: [String : [String: Any]]) {
        //var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        let annotation = MKPointAnnotation()  //Create a pin with an label
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: coordinates[0])!, longitude: CLLocationDegrees(exactly: coordinates[1])!)
        annotation.title = eventName  //creates the placemark with the name of the location
        //mapView.view(for: annotation)
        mapView.addAnnotation(annotation)   //officially adds this annotation
        let lst = [annotation.coordinate.latitude, annotation.coordinate.longitude]
        self.eventDict[lst] = eID
        //let span = MKCoordinateSpanMake(0.05, 0.05)  //sets the span of the region to be this wide
        //let region = MKCoordinateRegionMake(annotation.coordinate, span)  ///sets the region to be centered at the selected place and zooms to span
        //mapView.setRegion(region, animated: true)  //sets the region of the mapView to region
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let dest = segue.destination as! CommentsView
            dest.eid = transitionInfo
            dest.isPublic = true
            dest.eventType = self.eventType
        }
    }
    
}

extension GeoSport {
    
    func geofence(loc : String) -> Double {
        let strLoc = loc
        let locArr = strLoc.components(separatedBy: " ")
        let pi = Double.pi
        let l1 = Double(locArr[0])
        let l2 = Double(locArr[1])
        let lat1 = l1! * pi/180
        let long1 = l2! * pi/180
        let lat2 = Double((self.locationManager.location?.coordinate.latitude)!) * pi/180
        let long2 = Double((self.locationManager.location?.coordinate.longitude)!) * pi/180
        let dlon = long2 - long1
        let dlat = lat2 - lat1
        let a = pow(sin(dlat/2),2) + cos(lat1) * cos(lat2) * pow(sin(dlon/2), 2)
        let c = 2 * asin(min(1, sqrt(a)))
        let d = 3959 * c
        return d
    }
}


extension GeoSport {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isHidden {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
        let event = self.eventToDisplay!
        let numCom = (event["comments"] as? [String: Any])?.count ?? 0
        cell.fullInit(event["host"] as! String, evID: self.eid!, activity: event["eventType"] as! String, eventName: event["eventName"] as! String, numberParticipants: Int((event["numParticipants"] as! String))!, time: event["time"] as! String, loc: event["locationName"] as! String, numComments:  numCom, isPublic: true, parentView: self, indexPath: indexPath)
        //(event["comments"] as! [String: Any]).count
//        cell.fullInit((availablePosts[eid] as! [String: Any])["host"] as! String , evID: eid, activity: (availablePosts[eid] as! [String: Any])["eventType"] as! String, eventName: (availablePosts[eid] as! [String: Any])["eventName"] as! String, numberParticipants: Int((availablePosts[eid] as! [String: Any])["numParticipants"] as! String)!, time: (availablePosts[eid] as! [String: Any])["time"] as! String, loc: (availablePosts[eid] as! [String: Any])["locationName"] as! String, numComments: comments, parentView: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 401
    }
}

extension GeoSport {
    // Runs if the authorization is revoked: requests access again
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse { locationManager.requestLocation() }
    }
    
    // Runs if the user's location is updated; resets the location of the user
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Runs if there is an error gathers location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("error:: (error)")
    }
}

extension GeoSport {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        print("ayo ayo")
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        //pinView?.pinTintColor = UIColor.green
        pinView?.canShowCallout = true
        //tableView.isHidden = false
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //tableView.isHidden = false
        setView(view: tableView, hidden: false)
        let lst = [view.annotation!.coordinate.latitude, view.annotation!.coordinate.longitude]
        self.eventToDisplay = eventDict[lst]?.values.first
        self.eid = eventDict[lst]?.keys.first
        tableView.reloadData()
    }
    
}
