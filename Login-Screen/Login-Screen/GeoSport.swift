//
//  GeoSport.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class GeoSport: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var labelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
