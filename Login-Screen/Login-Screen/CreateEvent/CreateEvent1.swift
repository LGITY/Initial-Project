//
//  CreateEvent1.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CoreLocation

class CreateEvent1: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!

    
    let manager = CLLocationManager()
    var activityList: [String] = [String]() {
        didSet {
            //loadMembers()
            collectionView.reloadData()
        }
    }
    
    
    var ref: DatabaseReference?
    var pastSelection: SignUpActivityCell?
    var selection: String?
    
    
    struct Event {
        static var eventInfo: NSMutableDictionary = [:]
        static var place: CLLocationCoordinate2D?
        static var isPublic: Bool?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.textField.delegate = self
        
        manager.delegate = self as? CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = kCLDistanceFilterNone
        
        ref = Database.database().reference()
        
        //getting list of activities from firebase
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var tList = [String]()
            for key in (value?.allKeys)! {
                tList.append((value![key] as? String ?? ""))
            }
            self.activityList = tList.sorted()
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.resignFirstResponder()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        CreateEvent1.Event.eventInfo["eventName"] = self.textField.text
        CreateEvent1.Event.eventInfo["eventType"] = selection!
        self.performSegue(withIdentifier: "next", sender: self)
    }
}

extension CreateEvent1 {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath as IndexPath) as! SignUpActivityCell
        cell.fullInit(activityList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SignUpActivityCell
        if self.selection == cell.label.text! {
            cell.image.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
            cell.label.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        }
        else {
            cell.image.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
            cell.label.textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        }
        print("!! RECOGNIZED !!")
        self.pastSelection?.image.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        self.pastSelection?.label.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        self.pastSelection = cell
        self.selection = cell.label.text!
        
    }
}

extension CreateEvent1:
UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
