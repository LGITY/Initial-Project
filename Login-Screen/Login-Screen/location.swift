////
////  ViewController.swift
////  LocalWork
////
////  Created by Brad Levin on 8/21/18.
////  Copyright © 2018 Brad Levin. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
////import FirebdaseDatabase
//class ViewController: UIViewController, CLLocationManagerDelegate {
//    
//    let manager = CLLocationManager()
//    @IBOutlet weak var map: MKMapView!
//    //    var ref: DatabaseReference?
//
//    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    //        let location = locations[0]
//    //        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//    //        let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude , location.coordinate.longitude)
//    //        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
//    //        map.setRegion(region, animated: true)
//    //        self.map.showsUserLocation = true
//    //        print("latitutde:" ,location.coordinate.latitude)
//    //
//    //
//    //    }
//
//    override func viewDidLoad() {
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//        manager.distanceFilter = 15
//        //        let geoFenceRegion : CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(39.40836, -76.65959), radius: 10, identifier: "playArea")
//        print("location: ",manager.location?.coordinate)
//
//        //        manager.startMonitoring(for: geoFenceRegion)
//        //        ref = Database.database().reference()
//
//
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}

