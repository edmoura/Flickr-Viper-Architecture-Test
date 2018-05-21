//
//  PhotoSearchPresenter.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import Foundation

protocol PhotoSearchPresenterInput: PhotoViewControllerOutput, PhotoSearchInteractorOutput {
    
}

class PhotoSearchPresenter:PhotoSearchPresenterInput {
    
    var view:PhotoViewControllerInput!
    var interactor: PhotoSearchInteractorInput!
    
    //Presenter says interactor ViewController needs photos
    func fetchPhotos(_ searchTag:String , page: NSInteger) {
        interactor.fetchAllPhotosFromDataManager(searchTag, page: page)
    }
    
    //Service return photos and interactor passes all data to presenter which make view display them
    func providePhotos(_ photos:[FlickrPhotoModel], totalPages:NSInteger){
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
    }
    
    //Show error message from service
    func serviceError(_ error: NSError){
        self.view.displayErrorView(defaultErrorMessage)
    }
    
}
