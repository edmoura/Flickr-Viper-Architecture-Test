//
//  PhotoViewController.swift
//  FlickrViperArchitecture
//
//  Created by Edson iMAC on 20/05/2018.
//  Copyright © 2018 Edson Moura. All rights reserved.
//

import UIKit

protocol PhotoViewControllerOutput {
   func fetchPhotos(_ searchTag:String , page: NSInteger)
}

protocol PhotoViewControllerInput {
    func displayFetchedPhotos(_ photos:[FlickrPhotoModel], totalPages: NSInteger)
    func displayErrorView(_ errorMessage:String)
}

class PhotoViewController:UIViewController, PhotoViewControllerInput {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var presenter:PhotoViewControllerOutput!
    var photos:[FlickrPhotoModel] = []
    var currentPage = 1
    var totalPages = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PhotoSearchAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSearchWith(photoSearchKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = photoSearchKey
    }
    
    // Request photo service result from Presenter
    func performSearchWith(_ searchText:String) {
        presenter.fetchPhotos(searchText, page: currentPage)
    }
    
    // Presenter return us with photo results
    func displayFetchedPhotos(_ photos:[FlickrPhotoModel], totalPages: NSInteger){
        self.photos.append(contentsOf: photos)
        self.totalPages = totalPages
        
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    //Show Error
    func displayErrorView(_ errorMessage:String) {
        let refreshAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: OkKey, style: .default, handler: { (action) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Photo cell + Loading cell
        if currentPage < totalPages {
            return photos.count + 1
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < photos.count {
            return photoItemCell(collectionView, cellForItemAt: indexPath as NSIndexPath)
        } else {
            currentPage += 1
            performSearchWith(photoSearchKey)
            return loadingItemCell(collectionView, cellForItemAt: indexPath as NSIndexPath)
        }
    }
    
    func photoItemCell(_ collectionView:UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.defaultReuseIdentifier, for: indexPath as IndexPath) as! PhotoItemCell
        
        let flickrPhoto = self.photos[indexPath.row]
        
        cell.photoImageView.alpha = 0
        
        cell.photoImageView.sd_setImage(with: flickrPhoto.photoURL as URL) { (image, error, cache, withUrl) in
            cell.photoImageView.image = image
            UIView.animate(withDuration: 0.2, animations: {
                cell.photoImageView.alpha = 1.0
            })
        }
        
        return cell
    }
    
    func loadingItemCell(_ collectionView:UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLoadingCell.defaultReuseIdentifier, for: indexPath as IndexPath) as! PhotoLoadingCell
        
        return cell
    }
    
}

// MARK:- UICollectionViewDelegate
extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize:CGSize
        let length = (UIScreen.main.bounds.width) / 3 - 1
        
        if indexPath.row < photos.count {
            itemSize = CGSize(width: length, height: length)
        } else {
            itemSize = CGSize(width: photoCollectionView.bounds.width, height: 50.0)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
