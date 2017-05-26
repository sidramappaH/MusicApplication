//
//  MusicAPI.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit

class MusicAPI: NSObject {
    
   static let musicEndPoint = "https://itunes.apple.com/search?entity=song&limit=20"
    
   class func getMusicAPI(for searchTerm: String) -> String {
        
        return musicEndPoint + "&term=\(searchTerm)"
    }
}
