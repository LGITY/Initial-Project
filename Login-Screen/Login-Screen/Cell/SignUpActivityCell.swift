//
//  SignUpActivityCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpActivityCell: UICollectionViewCell {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    var activity: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fullInit(_ from : String) {
        activity = from
        label.text = from
        
        let storage = Storage.storage().reference().child("Activity Pictures").child(from + ".png")
        
        var image : UIImage? = UIImage()
        storage.downloadURL(completion: { (url, error) in
            if error != nil {
                return
            }
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                guard let imageData = UIImage(data: data! as Data) else { return }
                
                DispatchQueue.main.async {
                    image = imageData
                    self.image.image = image
                    self.image.image = self.image.image?.withRenderingMode(.alwaysTemplate)
                    self.image.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
                }
            }).resume()
        })
        
    }
}
