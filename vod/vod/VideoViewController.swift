//
//  VideoViewController.swift
//  vod
//
//  Created by Tomas Arguinzones on 18/8/17.
//  Copyright © 2017 Tomas Arguinzones. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoViewController: UIViewController {

    var avPlayer:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVideo()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.seek(to:kCMTimeZero)
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at:0)
        avPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
    }
    
    func initVideo(){
        avPlayer = AVPlayer(playerItem: AVPlayerItem(url: Bundle.main.url(forResource: "gigya", withExtension: "mp4")!))
        avPlayerLayer=AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        avPlayer.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }

    func playerItemDidReachEnd(notification:Notification){
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seek(to:kCMTimeZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
