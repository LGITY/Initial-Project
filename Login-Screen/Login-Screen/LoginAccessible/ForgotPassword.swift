//
//  ForgotPassword.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadbackground()

        // Do any additional setup after loading the view.
    }
    
    func loadbackground() {
//        let layer = UIView(frame: CGRect(x: -2, y: -2, width: 752, height: 1209))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
//        layer.layer.borderWidth = 10
//        layer.layer.borderColor = UIColor.white.cgColor
//        self.view.addSubview(layer)
        background.image = #imageLiteral(resourceName: "remi-jacquaint-519310-unsplash")
        background.contentMode = .scaleAspectFill
    }
    
    func loadNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
