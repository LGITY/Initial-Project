//
//  ComposeViewController.swift
//  Login-Screen
//
//  Created by Davis Booth on 6/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Description text field
    @IBOutlet weak var textView: UITextView!
    
    //activity picker
    @IBOutlet weak var activityPicker: UIPickerView!
    
    //reference to connect the Firebase Database
    var ref: DatabaseReference!
    
    //Database Handle that specifies the listener connection
    var databaseHandle: DatabaseHandle?
    
    //variable for the data to be populated in picker
    var pickerDataSource = [String]()
    //var pickerDataSource = ["Blah", "Blah Blah"]
    //variable to store the picker's choice
    var pickerChoice = "Basketball"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference implementation for Firebase
        ref = Database.database().reference()
        
        //picker set up
        self.activityPicker.dataSource = self
        self.activityPicker.delegate = self
        
        //picker populated through Firebase by retrieiving data
        //TODO: Go to the Code with Chris/Firebase documentation to read data from the Firebase Server
        ref?.child("Activities").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let achild = child as! DataSnapshot
                let ch = achild.value as! String
                self.pickerDataSource.append(ch)
            }
            self.activityPicker.reloadAllComponents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //adds a post to the Firebase database
    @IBAction func addPost(_ sender: Any) {
        //TODO: Post DATA to Firebase, dismiss the popup
        
        //Creates variable that will be written to Firebase, any specifications of the post should be visible in this variable
        let post = ["Description" : textView.text,
                    "Activity" : pickerChoice] as [String : Any]
        
        //Writes data to Firebase
        ref?.child("Posts").childByAutoId().setValue(post)
        
        //Closes view controller
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    //To cancel the post -- discard it completely
    @IBAction func cancelPost(_ sender: Any) {
        //rids the modal view controller and returns to table view
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //returns how many columns there are in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //returns how many rows there are in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    //returns each piece of data to be inserted in the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    //function runs every time the picker is changed to have a different choice selected; sets the global variable pickerChoice to the current choice
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerChoice = pickerDataSource[row]
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
