//
//  RCFlickrAPI.swift
//  RCPhotoAlbum
//
//  Comment: Flickr API URL Builder
//
//  Created by dilgir siddiqui on 2/19/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import UIKit

// Enum for URL request end points
enum FlickrAPIMethod: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

// Web Service request response
enum PhotosResult {
    case Success([RCPhoto])
    case Failure(Error)
}


enum FlickrError: Error {
    case InvalidJSONData // // Invalid Json error for Flickr API call
    case ImageCreationError // Image decoding error
}

// Image fetch web service request response
enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}


struct RCFlickrAPI {
    
    // Global variables for the Web Service call
    private static let baseURL = "https://api.flickr.com/services/rest"
    private static let apiKey = "5370bccc823d0e68c7875ac4f85422c4" // secret key: d38efa258fdb582e
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

extension RCFlickrAPI {
    
    static func recentPhotosURL() -> URL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras" : "url_h, date_taken"])
    }
    
    // Form the API Base URL with query parameters
    private static func flickrURL(method: FlickrAPIMethod, parameters: [String: String]?) -> URL {
        
        // For URL Components configuration
        var urlComponents = URLComponents(string: baseURL)
        
        // For adding query items to the URLComponents
        var queryItems = [URLQueryItem]()
        
        // Base parameters to be added to URLComponents
        var queryParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        if let additionalParams = parameters {
            queryParams.merge(additionalParams) { (_, new) in new }
        }
        
        // Add baseParams to queryItems
        for (key, value) in queryParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        // Set QueryItems into the URL Components
        urlComponents?.queryItems = queryItems
        
        return (urlComponents?.url)!
    }
}

extension RCFlickrAPI {
    
    static func photosFromJSONData(data: Data) -> PhotosResult {
        do {
            let jsonResponse: AnyObject = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as AnyObject
            print("Response: \(String(describing: jsonResponse))")
            guard let jsonDictionary = jsonResponse as? [String: AnyObject], let photos = jsonDictionary["photos"] as? [String: AnyObject], let photosArray = photos["photo"] as? [[String: AnyObject]]  else {
                // Invalid JSON
                return .Failure(FlickrError.InvalidJSONData)
            }
            var photosList = [RCPhoto]()
            for photoJSON in photosArray {
                if let photo = photosFromJSONObject(json: photoJSON) {
                    photosList.append(photo)
                }
            }
            return .Success(photosList)
        } catch {
            return .Failure(FlickrError.InvalidJSONData)
        }
    }
    
    static func photosFromJSONObject(json: [String: AnyObject]) -> RCPhoto? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        if photoID != "49470127181" { // Remove Dirty pic
            return RCPhoto(title: title, remoteURL: url, photoID: photoID, dateTaken: dateTaken)
        } else {
            return nil
        }
    }

}
