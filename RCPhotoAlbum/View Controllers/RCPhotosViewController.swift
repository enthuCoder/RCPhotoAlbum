//
//  RCPhotosViewController.swift
//  RCPhotoAlbum
//
//  Created by dilgir siddiqui on 2/18/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

class RCPhotosViewController: UIViewController, UICollectionViewDelegate {

    var photoStore: RCPhotoStore!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    let photosDataSource = RCPhotosDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photosCollectionView.dataSource = photosDataSource
        photosCollectionView.delegate = self
        
        loadPhotos()
    }
    
    // MARK: - Helper Methods
    private func loadPhotos() {
        photoStore.fetchRecentPhotos { (photosResult) in
            DispatchQueue.main.async { [unowned self] in
                switch photosResult {
                    case let .Success(photos):
                        print("Successfully found \(photos.count) recent photos.")
                        self.photosDataSource.photos = photos
                    case let .Failure(error):
                        print("Error fetching recent photos: \(error)")
                        self.photosDataSource.photos.removeAll()
                }
                self.photosCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
}


extension RCPhotosViewController {
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Photo to be loaded
        let photo = photosDataSource.photos[indexPath.row]
        
        // Download the image that needs to be shown
        photoStore.fetchImage(forPhoto: photo) { (result) in
            DispatchQueue.main.async { [unowned self] in
                let photoIndex = self.photosDataSource.photos.lastIndex(of: photo)!
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
                if let cell = self.photosCollectionView.cellForItem(at: photoIndexPath) as? RCPhotoCollectionViewCell {
                    cell.update(withImage: photo.image)
                }
            }
        }
    }
}

extension RCPhotosViewController {
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = photosCollectionView.indexPathsForSelectedItems?.first {
                let photo = photosDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! RCPhotoDetailsView
                destinationVC.photo = photo
                //destinationVC.store = store
            }
        }
    }

}
