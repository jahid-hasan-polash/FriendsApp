//
//  ImageCache.swift
//  FriendsApp
//
//  Created by JAHID HASAN POLASH on 22/5/21.
//

import UIKit

// To be served as a temporary image cache for this app
class ImageCache {
    static let global = ImageCache()
    
    // This disctionary will track on the images downloaded from internet
    // Dictionary Key will be the image urls
    var imagesDictionary = [String: UIImage]()
}
