//
//  ViewController.swift
//  RemoteControl
//
//  Created by Ali Gungor on 31.03.2018.
//  Copyright © 2018 Ali Gungor. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    var player: AVPlayer?
    private var volumeNotification = Notification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupRemoteCommandCenter(enable: true)
        setupVolumeObservation()
    }
    
    func setupRemoteCommandCenter(enable: Bool) {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        if enable {
            remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.playCommand.addTarget(self, action: #selector(remoteCommandCenterPlayCommandHandler))
            remoteCommandCenter.stopCommand.addTarget(self, action: #selector(remoteCommandCenterStopCommandHandler))
            remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(remoteCommandCenterPlayPauseCommandHandler))
        } else {
            remoteCommandCenter.pauseCommand.removeTarget(self, action: #selector(remoteCommandCenterPauseCommandHandler))
            remoteCommandCenter.playCommand.removeTarget(self, action: #selector(remoteCommandCenterPlayCommandHandler))
            remoteCommandCenter.stopCommand.removeTarget(self, action: #selector(remoteCommandCenterStopCommandHandler))
            remoteCommandCenter.togglePlayPauseCommand.removeTarget(self, action: #selector(remoteCommandCenterPlayPauseCommandHandler))
        }
        
        remoteCommandCenter.pauseCommand.isEnabled = enable
        remoteCommandCenter.playCommand.isEnabled = enable
        remoteCommandCenter.stopCommand.isEnabled = enable
        remoteCommandCenter.togglePlayPauseCommand.isEnabled = enable
    }
    
    func setupVolumeObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)), name: volumeNotification, object: nil)
    }
    
    deinit {
        setupRemoteCommandCenter(enable: false)
        NotificationCenter.default.removeObserver(self, name: volumeNotification, object: nil)
    }
    
    @objc func volumeChanged(notification: Notification) {
        guard let userInfo = notification.userInfo, let volume = userInfo["AVSystemController_AudioVolumeNotificationParameter"] else {
            return
        }
        print("volume changed: ")
        print(volume)
    }
    
    @objc func remoteCommandCenterPauseCommandHandler() {
        player?.pause()
    }
    
    @objc func remoteCommandCenterPlayCommandHandler() {
        player?.play()
    }
    
    @objc func remoteCommandCenterStopCommandHandler() {
        player?.pause()
    }
    
    @objc func remoteCommandCenterPlayPauseCommandHandler() {
        if player?.rate == 0.0 {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func setupPlayer() {
        let streamURL = URL(string: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8")!
        self.player = AVPlayer(url: streamURL)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        self.player?.play()
    }
    
    @IBAction func playButtonHandler(btn: UIButton) {
        setupRemoteCommandCenter(enable: true)
        setupPlayer()
    }
    
}
