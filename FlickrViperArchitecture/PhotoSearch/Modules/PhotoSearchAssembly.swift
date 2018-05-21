//
//  PhotoSearchAssembly.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import Foundation

class PhotoSearchAssembly {
    
    static let sharedInstance = PhotoSearchAssembly()
    
    func configure(_ viewController:PhotoViewController) {
        
        let APIDataManager = FlickrDataManager()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.APIDataManager = APIDataManager
        
    }
}
