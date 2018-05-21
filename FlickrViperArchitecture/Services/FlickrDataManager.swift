//
//  FlickrDataManager.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import Foundation
import SDWebImage

protocol FlickrPhotoSearchProtocol: class {
     func fetchPhotosForSearchText(searchText:String, page:NSInteger, clousure:@escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void
}

protocol FlickrPhotoLoadImageProtocol:class {
    func loadImageFromUrl(_ url:NSURL, closure:@escaping (UIImage?, NSError?) -> Void)
}

class FlickrDataManager:FlickrPhotoSearchProtocol, FlickrPhotoLoadImageProtocol {
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    struct FlickrAPIMetadataKeys {
        static let failureStatusCode = "code"
    }
    
    struct FlickrAPI {
        static let APIKEY = "d2ab34750d504d4eb9b768ef73aeffce"
        static let secret = "4753b3077ec3e62e"
        static let tagsSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@+&page=%i&format=json&nojsoncallback=1"
    }
    
    func fetchPhotosForSearchText(searchText:String, page:NSInteger, clousure:@escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void {

        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let format = FlickrAPI.tagsSearchFormat
        let arguments:[CVarArg] = [FlickrAPI.APIKEY, escapedSearchText!, page]
        
        let photosURL = String(format: format, arguments:arguments)
        let url = NSURL(string: photosURL)
        let request = URLRequest(url: url! as URL)
        
        let searchTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                clousure(error! as NSError, 0, nil)
            }
            
            do {
                
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results[FlickrAPIMetadataKeys.failureStatusCode] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
                        clousure(invalidAccessError, 0, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else {return}
                guard let totalPageCountString = photosContainer["total"] as? String else {return}
                guard let totalPageCount = NSInteger(totalPageCountString) else {return}
                
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else {return}
                
                let flickrPhotos:[FlickrPhotoModel] = photosArray.map({ (photoDictionary) -> FlickrPhotoModel in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhotoModel(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    
                    return flickrPhoto
                })
                
                clousure(nil, totalPageCount, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                clousure(error, 0, nil)
                return
            }
        }
        
        searchTask.resume()
        
    }
    
    // Memory cache photo service
    func loadImageFromUrl(_ url:NSURL, closure:@escaping (UIImage?, NSError?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url as URL?, options: .cacheMemoryOnly, progress: nil) { (image, data, error, cache, finished, withUrl) in
            if((image != nil) && finished) {
                closure(image, error! as NSError)
            }
        }
    }
}
