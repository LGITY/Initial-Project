//
//  SignUp2.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/24/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SignUp2: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //background element outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var profPicImage: UIImageView!
    
    //header outlets
    @IBOutlet weak var profPicButton: UIButton!
    @IBOutlet weak var profPicLabel: UILabel!
    
    //textview outlets
    @IBOutlet weak var firstBox: UIView!
    @IBOutlet weak var firstTextView: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var lastBox: UIView!
    @IBOutlet weak var lastTextView: UITextField!
    @IBOutlet weak var lastImage: UIImageView!
    @IBOutlet weak var facebookBox: UIView!
    @IBOutlet weak var facebookLabel: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    
    //dot outlets
    @IBOutlet weak var dotStack: UIStackView!
    @IBOutlet weak var dotFirst: UIView!
    @IBOutlet weak var dotSecond: UIView!
    @IBOutlet weak var dotThird: UIView!
    @IBOutlet weak var dotFourth: UIView!
    @IBOutlet weak var dotLast: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var signInStack: UIStackView!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    var info: Dictionary<String, String> = [:]
    

    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    override func viewDidLoad() {
        print("signUp2 info: ", info)
        super.viewDidLoad()
        firstTextView.delegate = self
        lastTextView.delegate = self
        
        //loads the background image
        loadBackground()
        
        //load add profile pic button
        profPicButton.layer.cornerRadius = profPicButton.frame.size.width/2
        profPicButton.backgroundColor = UIColor.lightGray
        profPicButton.alpha = 0.6
        
        //load profile picture image
        profPicImage.layer.cornerRadius = profPicImage.frame.size.width/2
        profPicImage.clipsToBounds = true
        profPicImage.isHidden = true
        
        //load profile picture label
        profPicLabel.text = "Add Profile Picture"
        profPicLabel.textAlignment = .center
        profPicLabel.textColor = UIColor.white
        
        //load first name
        loadTextView(firstTextView, box: firstBox, im: firstImage)
        firstImage.image = #imageLiteral(resourceName: "man")
        firstImage.contentMode = .scaleAspectFit
        firstTextView.attributedPlaceholder = NSAttributedString(string: "first name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load last name
        loadTextView(lastTextView, box: lastBox, im: lastImage)
        lastImage.image = #imageLiteral(resourceName: "man")
        lastImage.contentMode = .scaleAspectFit
        lastTextView.attributedPlaceholder = NSAttributedString(string: "last name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //loads facebook
        facebookBox.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1.0)
        facebookBox.layer.borderWidth = 2
        facebookBox.layer.borderColor = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1.0).cgColor
        facebookBox.layer.cornerRadius = 15
        facebookBox.layer.masksToBounds = true
        //loads the facebook logo next to the button
        facebookImage.contentMode = .scaleAspectFit
        facebookImage.image = #imageLiteral(resourceName: "facebookNew")
        
        //loads dots
        loadDots()
        
        //load next button
        nextButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstTextView.resignFirstResponder()
        lastTextView.resignFirstResponder()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPos(textField: UITextField) -> Double{
        let screenHeight = UIScreen.main.bounds.height
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        let pos = Int((globalPoint?.y)!)
        let sorted_pos = Double(pos)/4.5
        return sorted_pos
        
    }
    lazy var first_pos: Double = getPos(textField: firstTextView)
    lazy var last_pos: Double = getPos(textField: lastTextView)
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var sorted_pos = 0
        if textField == firstTextView {
            sorted_pos = Int(first_pos)
        }
        else {
            sorted_pos = Int(last_pos)
        }
        moveTextField(textField: textField, moveDistance: sorted_pos, up: true)
    }
    
    //    func CFDictionaryGetValue(_: CFDictionary!, _: UnsafeRawPointer!) -> UnsafeRawPointer!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var sorted_pos = 0
        if textField == firstTextView {
            sorted_pos = Int(first_pos)
        }
        else {
            sorted_pos = Int(last_pos)
        }
        moveTextField(textField: textField, moveDistance: sorted_pos, up: false)
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.2
        //this is an inline if statement that checks if up is true or not
        let movement : CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        //self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func profPicButton(_ sender: Any) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let theInfo: NSDictionary = info as NSDictionary
        if let img:UIImage = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as? UIImage {
            self.dismiss(animated: true, completion: nil)
            profPicImage.image = img
            profPicImage.contentMode = .scaleAspectFill
            profPicImage.isHidden = false
        }
        else {
            
        }
    }
    
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        backgroundImage.image = #imageLiteral(resourceName: "sign-up-background")
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    func loadDots() {
        
        //add green dot
        dotSecond.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotSecond.layer.cornerRadius = dotFirst.frame.size.width/2
        
        //adds grey dots
        let dotArray = [dotFirst, dotThird, dotFourth, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
        }
    }
    
    func loadTextView(_ textView: UITextField, box: UIView, im: UIImageView) {
        //loads the surrounding box for the username
        box.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1)
        box.layer.borderWidth = 2
        box.layer.borderColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1).cgColor
        box.layer.cornerRadius = 15
        box.layer.masksToBounds = true
        
        //loads the mail logo next to the username
        im.contentMode = .scaleAspectFit
        
        //loads the textfield for the username
        textView.backgroundColor = UIColor.clear
        textView.borderStyle = .none
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

extension SignUp2:
UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        firstTextView.resignFirstResponder()
        lastTextView.resignFirstResponder()
        return true
    }
}
