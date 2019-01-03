//
//  inMyAreaCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/22/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class inMyAreaCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Variables
    var ref: DatabaseReference?
    var parentViewController: Home?
    
    // Data array from server.
    var activityArr: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ref = Database.database().reference()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Disables scrollbars.
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        // Disables selection view change.
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        // Creates and registers nib.
        self.collectionView.register(UINib.init(nibName: "inMyAreaCollection", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        
        // Observe available activities from server.
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var tempArr: [String] = []
            for value in value!.allValues {
                tempArr.append(value as! String)
            }
            self.activityArr = tempArr
        })
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


// Extension for CollectionView delegate.
extension inMyAreaCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath as IndexPath) as! inMyAreaCollection
        let thisCell = activityArr[indexPath.item]
        cell.fullInit(thisCell)
        return cell
    }
    
    // Determines size of CollectionViewCells.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    // Perform segue to SportGeo upon tap.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentViewController?.syntheticPerform(activityArr[indexPath.item])
    }
    
    
}
