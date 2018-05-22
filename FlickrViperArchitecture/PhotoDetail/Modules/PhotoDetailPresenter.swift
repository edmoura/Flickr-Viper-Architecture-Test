//
//  PhotoDetailPresenter.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit

protocol PhotoDetailPresenterInput:PhotoDetailViewControllerOutput, PhotoDetailInteractorOutput {}

class PhotoDetailPresenter:PhotoDetailPresenterInput {
    
    weak var view:PhotoDetailViewControllerInput!
    var interactor:PhotoDetailInteractorInput!
    
    //Passing data from PhotoSearch Module Router
    func saveSelectedPhotoModel(_ photoModel:FlickrPhotoModel) {
        self.interactor.configurePhotoModel(photoModel)
    }
    
    func loadLargePhotoImage() {
        self.interactor.loadUIImageFromURL()
    }
    
    //result comes from Interactor
    func sendLoadedPhotoImage(_ url:NSURL) {
        self.view.addLargeLoadedPhoto(url)
    }
    
    func getPhotoImageTitle() {
        let imageTitle = self.interactor.getPhotoImageTitle()
        self.view.addPhotoImageTitle(imageTitle)
    }
}
