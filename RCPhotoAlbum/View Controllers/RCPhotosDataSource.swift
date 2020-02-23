//
//  RCPhotosDataSource.swift
//  RCPhotoAlbum
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

class RCPhotosDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [RCPhoto]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "RCPhotosCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RCPhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.update(withImage: photo.image)
        
        return cell
    }
}
