//
//  CreateEventMap.swift
//  Login-Screen
//
//  Created by Davis Booth on 10/22/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import MapKit

//specifies that this needs to be implemented in order to conform to the HandleMapSearch functionality
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class CreateEventMap: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil  //the pin that should be dropped based on user selection from the search results queue
    
    static var root: CreateEvent4?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the location manager
        locationManager.delegate = self  //sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //sets the accuracy of location to best possible accuracy
        locationManager.requestWhenInUseAuthorization()  //makes sure to seek user auth
        locationManager.requestLocation()  //requests the location of the user
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        
        //sets up the locationSearchTable to display the results of the search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView  //gives the locationSearchTable a way to reference the mapView in this controller
        locationSearchTable.handleMapSearchDelegate = self  //allows the locationSearchTable to handle the mapSearch
        
        //set up the search bar in this view controller
        let searchBar = resultSearchController!.searchBar  //creates search bar
        searchBar.sizeToFit()  //sizes search bar to be a natural size
        searchBar.placeholder = "Search for venues"  //placeholder text of the search bar
        navigationItem.titleView = resultSearchController?.searchBar  //not sure?
        
        //configures some customization of the search bar
        resultSearchController?.hidesNavigationBarDuringPresentation = false  //allows the search bar to still be seen while displaying results
        resultSearchController?.dimsBackgroundDuringPresentation = true  //dims the background of the results to display more clearly
        definesPresentationContext = true  //makes sure the search bar only takes up part of the view rather than the whole thing (default)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func setLocationPressed(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "back4", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? CreateEvent4{
            destinationViewController.locationCenter = selectedPin
            print("SelectedPinName")
            print(selectedPin?.name)
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        CreateEvent1.Event.place = mapView.centerCoordinate
    }
    
    @objc func setLocation() {
        CreateEventMap.root!.updateLocation(selectedPin!)
        self.dismiss(animated: true, completion: nil)
    }

}

//extends the class to implement a CLLocationManagerDelegate so that this class can properly deal with
extension CreateEventMap : CLLocationManagerDelegate {
    
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
        
        print("error:: (error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("error:: (error)")
    }
}


//extension to handle a tap on the search results queue
extension CreateEventMap: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark      // cache the pin to be used in the mapView
        mapView.removeAnnotations(mapView.annotations)   // clear existing pins in the mapView
        
        let annotation = MKPointAnnotation()  //Create a pin with an label
        annotation.coordinate = placemark.coordinate  //drops the pin in the right location
        annotation.title = placemark.name  //creates the placemark with the name of the location
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"  //if there is a city and a state, then include that as the subtitle of the pin
        }
        mapView.addAnnotation(annotation)   //officially adds this annotation
        let span = MKCoordinateSpanMake(0.05, 0.05)  //sets the span of the region to be this wide
        let region = MKCoordinateRegionMake(placemark.coordinate, span)  ///sets the region to be centered at the selected place and zooms to span
        mapView.setRegion(region, animated: true)  //sets the region of the mapView to region
    }
}

extension CreateEventMap : UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("We detectin' this bitch!")
        LocationSearchTable.matchingItems.removeAll()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("We detectin' this bitch!")
        LocationSearchTable.matchingItems.removeAll()
    }
}

extension CreateEventMap : MKMapViewDelegate {
    
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
   //     let smallSquare = CGSize(width: 30, height: 30)
    //    let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
    //    button.setBackgroundImage(UIImage(named: "filled-circle"), for: .normal)
   //     button.addTarget(self, action: #selector(CreateEventMap.setLocation), for: .touchUpInside)
  //      pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
}


