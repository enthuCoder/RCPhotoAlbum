//
//  RCPhotoStore.swift
//  RCPhotoAlbum
//
//  Comment: Network Manager to trigger Web Service Calls
//
//  Created by dilgir siddiqui on 2/19/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import UIKit

class RCPhotoStore {
    
    // Computed property for URL session
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
}

extension RCPhotoStore {
    
    // Fetch recent Photos and populate the Photo model
    func fetchRecentPhotos(completionHandler: @escaping (PhotosResult) -> Void) {
        // URL with request parameters
        let recentPhotosURL = RCFlickrAPI.recentPhotosURL()
        let request = URLRequest(url: recentPhotosURL)
        
        // Session Task to fetch web service response
        let fetchPhotosTask = session.dataTask(with: request) { (data, response, error) in
            print("HTTP response Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("URL Header Fields: \(String(describing: (response as? HTTPURLResponse)?.allHeaderFields))")
            if let error = error {
                completionHandler(.Failure(error))
            }
            guard let jsonData = data else {
                return completionHandler(.Failure(error!))
            }
            let result = RCFlickrAPI.photosFromJSONData(data: jsonData)
            return completionHandler(result)
        }
        fetchPhotosTask.resume()
    }
}

extension RCPhotoStore {
    
    // Fetch Image for Photo from recent photos
    func fetchImage(forPhoto photo: RCPhoto, completionHandler: @escaping (ImageResult) -> Void) {
        let request = URLRequest(url: photo.remoteURL)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completionHandler(.Failure(FlickrError.ImageCreationError))
            } else if data == nil {
                completionHandler(.Failure(error!))
            } else {
                guard let imageData = data, let image = UIImage(data: imageData) else {
                    return completionHandler(.Failure(FlickrError.ImageCreationError))
                }
                let result = ImageResult.Success(image)
                if case let .Success(image) = result {
                    photo.image = image
                }
                completionHandler(result)
            }
            
        }
        task.resume()
    }
}
