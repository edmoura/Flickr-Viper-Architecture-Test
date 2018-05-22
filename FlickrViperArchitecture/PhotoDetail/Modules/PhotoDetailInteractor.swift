//
//  PhotoDetailInteractor.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit

protocol PhotoDetailInteractorOutput:class {
     func sendLoadedPhotoImage(_ url:NSURL)
}

protocol PhotoDetailInteractorInput:class {
    func loadUIImageFromURL()
    func getPhotoImageTitle() -> String
    func configurePhotoModel(_ photoModel:FlickrPhotoModel)
}

class PhotoDetailInteractor:PhotoDetailInteractorInput  {
    
    weak var presenter:PhotoDetailInteractorOutput!
    var photoModel:FlickrPhotoModel?
    var imageDataManager:FlickrPhotoLoadImageProtocol!
    
    func configurePhotoModel(_ photoModel:FlickrPhotoModel) {
        self.photoModel = photoModel
    }
    
    func loadUIImageFromURL() {
        /*imageDataManager.loadImageFromUrl(self.photoModel!.largePhotoURL) { (image, error) in
            if let image = image {
                self.presenter.sendLoadedPhotoImage(image)
            }
        }
        //print("loadUIImageFromURL: \(String(describing: self.photoModel?.largePhotoURL))")*/
        
        self.presenter.sendLoadedPhotoImage(self.photoModel!.largePhotoURL)
    }
    
    func getPhotoImageTitle() -> String {
        if let title = self.photoModel?.title {
            return title
        }
        
        return ""
    }
    
}
