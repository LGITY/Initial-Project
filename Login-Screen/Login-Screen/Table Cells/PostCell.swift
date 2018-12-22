//
//  PostCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/10/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    
    //outlet for the activity image
    @IBOutlet weak var acImg: UIImageView!
    
    //outlet for the description label text
    @IBOutlet weak var desc: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //this function basically just acts as a constructor to set everything up (strictly for ease instead of doing it manually
    func commonInit(_ imageName: String, description: String) {
        acImg.image = UIImage(named: imageName)
        desc.text = description
    }
    
}
