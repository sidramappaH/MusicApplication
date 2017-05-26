//
//  MusicLibraryCell.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit

class MusicLibraryCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak fileprivate var thumbImageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var artistNameLabel: UILabel!
    @IBOutlet weak fileprivate var durationLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bezierPath = UIBezierPath.init(rect: bounds)
        layer.masksToBounds = false
        layer.shadowOffset = CGSize.init(width: 0.0, height: 5.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowPath = bezierPath.cgPath
    }
    
    //MARK:- Custom Methods
    func configureCell(for music: Music) {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(red: 173/255, green: 173/255, blue: 173/255, alpha: 1).cgColor
        if let url = music.trackImaageWith100Size {
            MusicDownloadManager.sharedInstance.downlodImage(from: url, completionHandler: { [weak self](image, error) in
                self?.thumbImageView.image = image
            })
        }
        
        titleLabel.text = music.trackName
        artistNameLabel.text = music.artistName
    }
}






