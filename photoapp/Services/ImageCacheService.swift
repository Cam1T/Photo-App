//
//  ImageCacheService.swift
//  photoapp
//
//  Created by USER on 17/08/2020.
//  Copyright © 2020 CJAPPS. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheService {
    
    static var imageCache = [String:UIImage]()
    
    static func saveImage(url:String?, image:UIImage?) {
    
    // Check against nil
    if url == nil || image == nil {
    return
    }
        
        // Save the image
        imageCache[url!] = image!
    }
    
    static func getImage(url:String?) -> UIImage? {
        
        // Check that url isn't nil
        if url == nil {
            return nil
        }
        
        // Check the image cache for the url
        return imageCache[url!]
    }
}
