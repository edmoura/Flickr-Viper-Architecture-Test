//
//  PhotoDetailViewController.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoDetailViewControllerInput:class {
    func addLargeLoadedPhoto(_ url:NSURL)
    func addPhotoImageTitle(_ title:String)
}

protocol PhotoDetailViewControllerOutput:class {
    func saveSelectedPhotoModel(_ photoModel:FlickrPhotoModel)
    func loadLargePhotoImage()
    func getPhotoImageTitle()
}

class PhotoDetailViewController: UIViewController, PhotoDetailViewControllerInput {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var presenter:PhotoDetailViewControllerOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoDetailAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ask title and image from presenter
        self.presenter.getPhotoImageTitle()
        self.presenter.loadLargePhotoImage()
    }
    
    //result comes from presenter
    func addLargeLoadedPhoto(_ url:NSURL) {
        self.photoImageView.alpha = 0;
        self.photoImageView.sd_setImage(with: url as URL) { (image, error, cache, withUrl) in
            self.photoImageView.image = image
            self.activityLoader.stopAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.photoImageView.alpha = 1.0
            })
        }
    }
    
    func addPhotoImageTitle(_ title: String) {
        self.photoTitleLabel.text = title.capitalized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
