//
//  PlayerViewController.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 25/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {
    //MARK:- @IBOutlet
    @IBOutlet weak fileprivate var musicImageView: UIImageView!
    @IBOutlet weak fileprivate var songTitleLabel: UILabel!
    @IBOutlet weak fileprivate var slider: UISlider!
    @IBOutlet weak fileprivate var artistNameLabel: UILabel!
    @IBOutlet weak fileprivate var nextButton: UIButton!
    @IBOutlet weak fileprivate var pauseOrPlayButton: UIButton!
    @IBOutlet weak fileprivate var previousButton: UIButton!
    
    //MARK:- Properties
    fileprivate var musicPlayer: AVPlayer?
    fileprivate var musicArray: [Music]?
    fileprivate var selectedIndex = NSNotFound
    fileprivate var flag = false
    
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedIndex == ((musicArray?.count ?? 0) - 1) {
            nextButton.isEnabled = false
        } else if selectedIndex == 0{
            previousButton.isEnabled = false
        }
        
        if selectedIndex != NSNotFound,let music = musicArray?[selectedIndex] {
            flag = false
            addActivateIndicator()
            setUpMusicPlayer(for: music)
            configureControlCentreForMusicPlayer(for: music)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        musicPlayer?.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- @IBAction methods
    
    @IBAction func didTapPauseOrPlayButton(_ sender: UIButton) {
        
        if  let musicPlayer = musicPlayer, musicPlayer.timeControlStatus == .playing {
            musicPlayer.pause()
            sender.setImage(UIImage.init(named: "Play Filled-100"), for: .normal)
        } else {
            musicPlayer?.play()
            sender.setImage(UIImage.init(named: "Pause Filled-100"), for: .normal)
        }
    }
    
    @IBAction func didTapPreviousButton(_ sender: UIButton) {
        
        stopActivityIndicator()
        previousButton.isEnabled = true
        nextButton.isEnabled = true
        addActivateIndicator()
        flag = false
        if let count = musicArray?.count, selectedIndex < count, selectedIndex > 0{
            selectedIndex -= 1
            if let music = musicArray?[selectedIndex] {
                setUpMusicPlayer(for: music)
                configureControlCentreForMusicPlayer(for: music)
            }
        }
        if selectedIndex == 0 {
            previousButton.isEnabled = false
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        
        stopActivityIndicator()
        previousButton.isEnabled = true
        nextButton.isEnabled = true
        addActivateIndicator()
        flag = false
        selectedIndex += 1
        if let count = musicArray?.count, selectedIndex < count {
            if let music = musicArray?[selectedIndex] {
                setUpMusicPlayer(for: music)
                configureControlCentreForMusicPlayer(for: music)
            }
        }
        
        if selectedIndex == ((musicArray?.count) ?? 0) - 1{
            nextButton.isEnabled = false
        }
    }
    
    func updateSliderValue() {
        if slider.value > 0 && !flag {
            stopActivityIndicator()
            flag = true
        }
        slider.isContinuous = true
        if let currentTime =  musicPlayer?.currentTime().seconds{
            slider.setValue(Float(currentTime), animated: true)
        }
    }
    
    
    func playerDidFinishPlaying(note: NSNotification) {
        slider.value = 0
        didTapNextButton(UIButton())
    }
}

//MARK:- Public Methods
extension PlayerViewController {
    ///Returns a proper initialized object of PlayerViewController.
    class func controller(for musicArray: [Music], selectedIndex: Int) -> PlayerViewController {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        controller.musicArray = musicArray
        controller.selectedIndex = selectedIndex
        return controller
    }
}


//MARK:- Private Methods
private extension PlayerViewController {
    
    ///Create the musicplayer by using the provided urlstring
    
    func createMusicPlayer(for urlString: String) {
        if let url = URL.init(string: urlString) {
            musicPlayer = AVPlayer.init(url: url)
            musicPlayer?.play()
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSliderValue), userInfo: nil, repeats: true)
            if let mTrackTime = musicArray?[selectedIndex].mTrackTime{
                slider.maximumValue = Float(7 + mTrackTime/10000)
            }
            if let musicPlayer = musicPlayer {
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: musicPlayer.currentItem)
            }
        }
    }
    
    //Do the initial setup for player view controller.
    func setUpMusicPlayer(for music: Music) {
        if let imageURL = music.trackImaageWith100Size {
            MusicDownloadManager.sharedInstance.downlodImage(from: imageURL, completionHandler: { (image, error) in
                self.musicImageView.image = image
            })
        }
        songTitleLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        
        if let urlString = music.trackPreviewURL {
            createMusicPlayer(for: urlString)
        }
    }
    
    //It will configure the Control centre. It won't work properly in stimualtor.Test it in device to get proper result
    func configureControlCentreForMusicPlayer(for music: Music) {
        var dict = [String:AnyObject]()
        dict[MPMediaItemPropertyTitle] = music.trackName as AnyObject
        if let trackTime = music.mTrackTime {
            dict[MPMediaItemPropertyPlaybackDuration] = trackTime/10000 as AnyObject
        }
        dict[MPNowPlayingInfoPropertyPlaybackRate] = 1.0 as AnyObject
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dict
        MPNowPlayingInfoCenter.default()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            musicPlayer?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        MPRemoteCommandCenter.shared().playCommand.addTarget { (remoteCommandCentre) -> MPRemoteCommandHandlerStatus in
            self.musicPlayer?.play()
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { (remoteCommandCentre) -> MPRemoteCommandHandlerStatus in
            
            self.musicPlayer?.pause()
            return .success        }
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (remoteCommandCentre) -> MPRemoteCommandHandlerStatus in
            self.didTapNextButton(UIButton())
            return .success
        }
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (remoteCommandCentre) -> MPRemoteCommandHandlerStatus in
            self.didTapPreviousButton(UIButton())
            return .success
        }
    }
}
