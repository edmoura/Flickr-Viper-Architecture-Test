//
//  PhotoSearchInteractor.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import Foundation

protocol PhotoSearchInteractorInput: class {
     func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger)
}

protocol PhotoSearchInteractorOutput: class {
    func providePhotos(_ photos:[FlickrPhotoModel], totalPages:NSInteger)
    func serviceError(_ error: NSError)
}

class PhotoSearchInteractor:PhotoSearchInteractorInput {
    
    var presenter: PhotoSearchInteractorOutput!
    var APIDataManager: FlickrPhotoSearchProtocol!
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger) {
        
        APIDataManager.fetchPhotosForSearchText(searchText: searchTag, page: page) { (error, totalPages, flickrPhotos) in
            if let photos = flickrPhotos {
                self.presenter.providePhotos(photos, totalPages: totalPages)
            }
            else if let error = error {
                self.presenter.serviceError(error)
            }
        }
        
    }
    
}
