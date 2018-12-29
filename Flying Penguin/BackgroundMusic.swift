//
//  BackgroundMusic.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/29.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import AVFoundation

class BackgroundMusic: NSObject {
    // create the clas as a singleton
    static let instance = BackgroundMusic()
    var musicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic() {
        // Start the background music:
        if let musicPath = Bundle.main.path(forResource: "Sound/BackgroundMusic.m4a", ofType: nil) {
            let url = URL(fileURLWithPath: musicPath)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.play()
            } catch {
                /* Could't load music file */
            }
        }
        
        if isMuted(){
            pauseMusic()
        }
    }
    
    func pauseMusic() {
        UserDefaults.standard.set(true, forKey: "BackgroundMusicState")
        musicPlayer.pause()
    }
    
    func playMusic() {
        UserDefaults.standard.set(false, forKey: "BackgroundMusicState")
        musicPlayer.play()
    }
    
    // Check mute state
    func isMuted() -> Bool {
        if UserDefaults.standard.bool(forKey: "BackgroundMusicState") {
            return true
        } else {
            return false
        }
    }
    
    func setVolume(volume: Float) {
        musicPlayer.volume = volume
    }
}
