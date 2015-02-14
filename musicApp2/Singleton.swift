//
//  Singleton.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 1/22/15.
//  Copyright (c) 2015 Ido Ben-Natan. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class IBNPlayer: NSObject {
    class func getPlayerController() -> AVPlayerViewController {
        return AVPlayerViewController()
    }
    
    class func getPlayer(playerItem: AVPlayerItem) -> AVPlayer {
        return AVPlayer(playerItem: playerItem)
    }
}