//
//  CreateEvent4.swift
//  Login-Screen
//
//  Created by Davis Booth on 10/22/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class CreateEvent4: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    let locationManager = CLLocationManager()
    
    var ref: DatabaseReference?
    var distance: Double = 0.0
    var observedLocation: Array<String>?
    
    
    
    var locationCenter: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self  //sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //sets the accuracy of location to best possible accuracy
        locationManager.requestWhenInUseAuthorization()  //makes sure to seek user auth
        locationManager.requestLocation()  //requests the location of the user
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        if locationCenter != nil{
            locationField.text = locationCenter?.name
        }
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateEvent4.pressed(_:)) ))
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    
    func updateLocation(_ location: MKPlacemark) {
        locationCenter = location
        let span = MKCoordinateSpanMake(0.05, 0.05)  //sets the span of the region to be this wide
        let region = MKCoordinateRegionMake(location.coordinate, span)  ///sets the region to be centered at the selected place and zooms to span
        mapView.setRegion(region, animated: true)  //sets the region of the mapView to region
        mapView.removeAnnotations(mapView.annotations)   // clear existing pins in the mapView
        
        let annotation = MKPointAnnotation()  //Create a pin with an label
        annotation.coordinate = location.coordinate  //drops the pin in the right location
        annotation.title = location.name  //creates the placemark with the name of the location
        if let city = location.locality,
            let state = location.administrativeArea {
            annotation.subtitle = "\(city) \(state)"  //if there is a city and a state, then include that as the subtitle of the pin
        }
        mapView.addAnnotation(annotation)   //officially adds this annotation
        
        // Deletes users if they are out of the desired radius.
        for id in CreateEvent2.invitedArr {
            self.ref?.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value  = snapshot.value as! [String: Any]
                let strLoc = value["location"] as! String
                let locArr = strLoc.components(separatedBy: " ")
                let pi = Double.pi
                let l1 = Double(locArr[0])
                let l2 = Double(locArr[1])
                let lat1 = l1! * pi/180
                let long1 = l2! * pi/180
                let lat2 = Double((self.locationCenter?.coordinate.latitude)!) * pi/180
                let long2 = Double((self.locationCenter?.coordinate.longitude)!) * pi/180
                let dlon = long2 - long1
                let dlat = lat2 - lat1
                let a = pow(sin(dlat/2),2) + cos(lat1) * cos(lat2) * pow(sin(dlon/2), 2)
                let c = 2 * asin(min(1, sqrt(a)))
                let d = 3959 * c
                print("distttt", d)
                if d > 10 {
                    print("got here at least")
                    CreateEvent2.invitedArr.remove(id)
                }
                CreateEvent1.Event.eventInfo["availableTo"] = Array(CreateEvent2.invitedArr)
            })
        }
        
    }
    
    
    @IBAction func dragging(_ sender: Any) {
    }
    
    @objc func pressed(_ sender: Any) {
        CreateEventMap.root = self
        self.performSegue(withIdentifier: "toFullMap", sender: self)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        CreateEvent1.Event.eventInfo["time"] = pickerView.date.description
        let coord = locationCenter!.coordinate.latitude.description + " " + locationCenter!.coordinate.longitude.description
        CreateEvent1.Event.eventInfo["location"] = coord
        CreateEvent1.Event.eventInfo["host"] = SignUp1.User.uid
        CreateEvent1.Event.eventInfo["locationName"] = locationField.text
        
        //creates an id that it uses twice
        let id = UUID().uuidString
        self.ref?.child("Events").child(id).setValue(CreateEvent1.Event.eventInfo)
        if !CreateEvent1.Event.isPublic! {
            ref?.child("Users").child(SignUp1.User.uid).child("Events").child(id).setValue("Event")
            
            let arr = CreateEvent1.Event.eventInfo["availableTo"] as! [String]
            for user in arr {
                if user.first != "-" {
                    ref?.child("Users").child(user).child("Events").child(id).setValue("Event")
                }
                else {
                    print("Do something for groups")
                }
            }
            ref?.child("Events").child(id).child("attendees").childByAutoId().setValue(SignUp1.User.uid)
        }
        else {
            self.ref?.child("Public Events").child((CreateEvent1.Event.eventInfo["eventType"] as! String)).child(id).setValue(CreateEvent1.Event.eventInfo)
        }
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
//    func get_dist(_ id: String) {
//        var locArr = [String]()
//
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extends the class to implement a CLLocationManagerDelegate so that this class can properly deal with
extension CreateEvent4 : CLLocationManagerDelegate {
    
    // runs if the authorization is revoked: requests access again
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse { locationManager.requestLocation() }
    }
    
    // runs if the user's location is updated; resets the location of the user
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    //runs if there is an error gathers location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("error:: \(error)")
    }
}
