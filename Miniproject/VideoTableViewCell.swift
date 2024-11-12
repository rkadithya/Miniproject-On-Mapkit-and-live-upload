//
//  ViewTableViewCell.swift
//  Miniproject
//
//  Created by apple on 11/11/24.
//

import Foundation
import UIKit
import AVFoundation
class VideoTableViewCell: UITableViewCell{
    public var player : AVPlayer?
    public var playerLayer : AVPlayerLayer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    
    func configure(with videoURL : URL){
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.contentView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
        player?.play()
    }
    
}
