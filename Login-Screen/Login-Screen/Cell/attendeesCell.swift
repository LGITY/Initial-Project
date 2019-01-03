//
//  attendeesCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 1/2/19.
//  Copyright © 2019 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class attendeesCell: UICollectionViewCell {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var ref: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        profPic.layer.cornerRadius = profPic.frame.height/8
        profPic.contentMode = .scaleToFill
        profPic.clipsToBounds = true
    }
    
    func fullInit(_ userID: String) {
        self.ref?.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String: Any]
            self.label.text = (value["first"] as! String) + " " + (value["last"] as! String)
            let urlPath = value["prof-pic"] as? String
            if let profUrl = urlPath {
                let surl = URL(string: profUrl)
                let url = URLRequest(url: surl!)
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profPic.image = UIImage(data: data!)
                    }
                    
                    }.resume()
                
            }
        })
    }
}
