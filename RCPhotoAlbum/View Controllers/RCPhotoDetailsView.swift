//
//  RCPhotoDetailsView.swift
//  RCPhotoAlbum
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

class RCPhotoDetailsView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: RCPhoto! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OperationQueue.main.addOperation {
            self.imageView.image = self.photo.image
        }
    }
}
