//
//  FlickrPhotoModel.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import Foundation

struct FlickrPhotoModel {
    
    let photoId:String
    let farm: Int
    let secret:String
    let server:String
    let title:String
    
    var photoURL:NSURL {
        return flickrImageURL()
    }
    
    var largePhotoURL:NSURL {
        return flickrImageURL(size: "b")
    }

    private func flickrImageURL(size:String = "m") -> NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg")!
    }
    
}
