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
    
    //var store: RCPhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OperationQueue.main.addOperation {
            self.imageView.image = self.photo.image
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
