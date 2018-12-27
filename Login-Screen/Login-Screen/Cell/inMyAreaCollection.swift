//
//  inMyAreaCollection.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/22/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseStorage

class inMyAreaCollection: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
    }
    
    
    func fullInit(_ activity: String) {
        // Set text.
        label.text = activity.uppercased()
        
        // Set image.
        setImage()
    }
    
    
    // Sets image for this activity.
    func setImage() {
        
        let formatted = label.text!.lowercased().capitalized
        let storage = Storage.storage().reference().child("HomePics").child(formatted + "-img.jpg")
        
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
                    self.imageView.image = image    // Set image to downloaded image.
                }
            }).resume()
        })
    }

}
