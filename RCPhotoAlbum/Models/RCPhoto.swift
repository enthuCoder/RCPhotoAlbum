//
//  RCPhoto.swift
//  RCPhotoAlbum
//
//  Comments: Model to store data points from Web Service response
//
//  Created by dilgir siddiqui on 2/18/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import UIKit

// Model to store data points from Web Service response
class RCPhoto {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    var image: UIImage? = nil
    
    init(title: String, remoteURL: URL, photoID: String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
}

extension RCPhoto: Equatable {
    
    static func == (lhs: RCPhoto, rhs: RCPhoto) -> Bool {
        return (lhs.photoID == rhs.photoID) ? true : false
    }
}
