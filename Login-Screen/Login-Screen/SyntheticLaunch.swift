//
//  SyntheticLaunch.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SyntheticLaunch: UIViewController {
    var moviePlayer: AVPlayerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo(from: "sample1.mov")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
            self.performSegue(withIdentifier: "toApp", sender: self)
        })
    }
    
    private func playVideo(from file:String) {
        let file = file.components(separatedBy: ".")
        
        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            print( "\(file.joined(separator: ".")) not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        print("here!!")
        player.play()
        
    }

}
