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

class GeoSport: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var sport: String?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sport)
        self.title = sport! + " in my Area"
        ref = Database.database().reference()
        locationManager.delegate = self  //sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //sets the accuracy of location to best possible accuracy
        locationManager.requestWhenInUseAuthorization()  //makes sure to seek user auth
        locationManager.requestLocation()  //requests the location of the user
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        ref?.child("Public Events").child(self.sport!).observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as? [String: [String: Any]]
            if let value = val {
                for game in value.keys {
                    let coordString = value[game]!["location"] as! String
                    let coordArr = coordString.split(separator: " ")
                    let eName = value[game]!["eventName"] as! String
                    // TODO :: Check if it is within the radius of the user
                    self.addPin([Double(coordArr[0])!, Double(coordArr[1])!], eventName: eName)
                }
            }
        })
        //addPin([39.4428341, -76.6628712], eventName: "Basketball 2.0")
    }
    
    func addPin(_ coordinates: [Double], eventName: String) {
        //var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        let annotation = MKPointAnnotation()  //Create a pin with an label
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: coordinates[0])!, longitude: CLLocationDegrees(exactly: coordinates[1])!)
        annotation.title = eventName  //creates the placemark with the name of the location
        //mapView.view(for: annotation)
        mapView.addAnnotation(annotation)   //officially adds this annotation
        //let span = MKCoordinateSpanMake(0.05, 0.05)  //sets the span of the region to be this wide
        //let region = MKCoordinateRegionMake(annotation.coordinate, span)  ///sets the region to be centered at the selected place and zooms to span
        //mapView.setRegion(region, animated: true)  //sets the region of the mapView to region
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
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.green
        pinView?.canShowCallout = true
//        let view = UIView(frame: CGRect.zero)
//        view.backgroundColor = UIColor.black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let c1 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: self.mapView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.3, constant: 0)
//        let c2 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
//        let c3 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: self.mapView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 5)
//        let c4 = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        self.view.addSubview(view)
//        self.view.addConstraint(c1)
//        self.view.addConstraint(c2)
//        self.view.addConstraint(c3)
//        self.view.addConstraint(c4)
//        self.mapView.isHidden = true
        
             let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "HoopsIcon"), for: .normal)
             button.addTarget(self, action: #selector(CreateEventMap.setLocation), for: .touchUpInside)
              pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
