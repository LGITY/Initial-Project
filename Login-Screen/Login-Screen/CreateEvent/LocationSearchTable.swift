//
//  LocationSearchTable.swift
//  Login-Screen
//
//  Created by Davis Booth on 10/27/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import MapKit   //allows use of map-related methods

class LocationSearchTable: UITableViewController {
    
    static var matchingItems:[MKMapItem] = []  //the list of matching locations
    
    var mapView: MKMapView? = nil  //the mapview from the CreateEventMap controller

    var handleMapSearchDelegate: HandleMapSearch? = nil  //the map handler from CreateEventMap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationSearchTable.matchingItems.removeAll()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between number and road name
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""  //checks if both exist
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""  //makes sure that a street name or street number exists and a state name or city name exists (if they don't, no reason for a comma to exist)
        
        
        // put a space between city and state
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : "" //checks to make sure they both exist
        
        let addressLine = String(  //builds the full thing
            format:"%@%@%@%@%@%@%@", //not exactly sure why this is necessary
            
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            
            // city
            selectedItem.locality ?? "",
            secondSpace,
            
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    

    
}

//extension to make LocationSearchTable compatible with the UISearchResultsUpdating delegate
extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        LocationSearchTable.matchingItems.removeAll()
        guard let mapView = mapView,     //checks to see if these values are set; if they are, continue; if not, return
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()   //creates the search request to be sent
        request.naturalLanguageQuery = searchBarText  //sets the search request text to the text in the search bar
        request.region = mapView.region  //sets the region (probably zipcode) to be equal to the mapView's region (the region of current user)
        let search = MKLocalSearch(request: request) //performs the search
        search.start { response, _ in                //starts the search
            guard let response = response else {     //makes sure there is a response; if not return
                return
            }
            LocationSearchTable.matchingItems = response.mapItems  //update the matching items to contain the items that matched in the search
            self.tableView.reloadData()  //reloads the data to be updated with this information
        }
        self.tableView.reloadData()
    }
    
}


//extension that implements the TableView delegate methods
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationSearchTable.matchingItems.count  //how many cells to create
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!  //dequeues the cell in TableViewController to be reused
        let selectedItem = LocationSearchTable.matchingItems[indexPath.row].placemark  //finds the name of the place that the search returned for this cell
        cell.textLabel?.text = selectedItem.name  //sets the title text equal to the name of this place
        //matchingItems[indexPath.row].description
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)   //sets the detail text equal to address deduced from the placemark
        return cell
    }
    
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = LocationSearchTable.matchingItems[indexPath.row].placemark  //sets the selected item to the current selection's placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)  //drops the pin at this location
        dismiss(animated: true, completion: nil)    //dismisses the search view's view controller
    }
}
