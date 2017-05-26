//
//  Music.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit

//Sample Response
//{
//    "wrapperType": "track",
//    "kind": "song",
//    "artistId": 940710524,
//    "collectionId": 1067479738,
//    "trackId": 1067479908,
//    "artistName": "Lil Uzi Vert",
//    "collectionName": "Luv Is Rage",
//    "trackName": "Top",
//    "collectionCensoredName": "Luv Is Rage",
//    "trackCensoredName": "Top",
//    "artistViewUrl": "https://itunes.apple.com/us/artist/lil-uzi-vert/id940710524?uo=4",
//    "collectionViewUrl": "https://itunes.apple.com/us/album/top/id1067479738?i=1067479908&uo=4",
//    "trackViewUrl": "https://itunes.apple.com/us/album/top/id1067479738?i=1067479908&uo=4",
//    "previewUrl": "http://a1465.phobos.apple.com/us/r30/Music2/v4/59/c6/6e/59c66e6e-4ec8-b363-e334-9e2d63783894/mzaf_594532439915206706.plus.aac.p.m4a",
//    "artworkUrl30": "http://is3.mzstatic.com/image/thumb/Music69/v4/bb/92/e7/bb92e720-2995-9b3b-abaf-27bfd399dd5a/source/30x30bb.jpg",
//    "artworkUrl60": "http://is3.mzstatic.com/image/thumb/Music69/v4/bb/92/e7/bb92e720-2995-9b3b-abaf-27bfd399dd5a/source/60x60bb.jpg",
//    "artworkUrl100": "http://is3.mzstatic.com/image/thumb/Music69/v4/bb/92/e7/bb92e720-2995-9b3b-abaf-27bfd399dd5a/source/100x100bb.jpg",
//    "collectionPrice": 7.99,
//    "trackPrice": 1.29,
//    "releaseDate": "2015-12-18T08:00:00Z",
//    "collectionExplicitness": "explicit",
//    "trackExplicitness": "explicit",
//    "discCount": 1,
//    "discNumber": 1,
//    "trackCount": 12,
//    "trackNumber": 7,
//    "trackTimeMillis": 236000,
//    "country": "USA",
//    "currency": "USD",
//    "primaryGenreName": "Hip-Hop",
//    "contentAdvisoryRating": "Explicit",
//    "isStreamable": true
//},

class Music: NSObject {
    
    let artistName: String?
    let trackName: String?
    let trackPreviewURL: String?
    let trackImaageWith60Size: String?
    let trackImaageWith100Size: String?
    let mTrackTime: Int?

    init(dictionary: [AnyHashable: Any]) {
        artistName = dictionary.getOptionalString(for: "artistName")
        trackName = dictionary.getOptionalString(for: "trackName")
        trackImaageWith60Size = dictionary.getOptionalString(for: "artworkUrl60")
        trackImaageWith100Size = dictionary.getOptionalString(for: "artworkUrl100")
        trackPreviewURL = dictionary.getOptionalString(for: "previewUrl")
        mTrackTime = dictionary.getInt(for: "trackTimeMillis")
    }
    
    class func getMusicArray(from response: [Any]) -> [Music]? {
        
        var musicArray: [Music] = []
                
            for dictioanry in response {
                
                if let dict = dictioanry as? [AnyHashable: Any]{
                    musicArray.append(Music.init(dictionary: dict))
                }
            }
        print(musicArray.count)
        return musicArray.isEmpty ? nil : musicArray
    }
}
