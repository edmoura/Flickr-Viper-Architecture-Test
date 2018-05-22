//
//  PhotoSearchRouting.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit

protocol PhotoSearchRouterInput:class {
    func navigateToPhotoDetail()
    func passDataToNextScene(_ segue:UIStoryboardSegue)
}

class PhotoSearchRouting:PhotoSearchRouterInput {
    
    weak var viewController:PhotoViewController!
    
    //MARK:- Navigation
    func navigateToPhotoDetail() {
        viewController.performSegue(withIdentifier: "ShowPhotoDetail", sender: nil)
    }
    
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        if segue.identifier == "ShowPhotoDetail" {
            passDataShowPhotoDetailScene(segue)
        }
    }
    
    // navigate to another module
    func passDataShowPhotoDetailScene(_ segue: UIStoryboardSegue) {
        if let selectedIndexPath = viewController.photoCollectionView.indexPathsForSelectedItems?.first {
            
            let selectedPhotoModel = viewController.photos[selectedIndexPath.row]
            let showDetailViewController = segue.destination as! PhotoDetailViewController
            
            showDetailViewController.presenter.saveSelectedPhotoModel(selectedPhotoModel)
        }
    }
}
