//
//  RCPhotoCollectionViewCell.swift
//  RCPhotoAlbum
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

class RCPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(withImage: nil)
    }
    
    // Use this to clean up the cell before reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        update(withImage: nil)
    }
    
    // Helper method to update image in the cell
    func update(withImage image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
