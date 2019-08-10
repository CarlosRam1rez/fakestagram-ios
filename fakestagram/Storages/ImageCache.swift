//
//  ImageCache.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 5/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    let filename: String
    private let cache = NSCache<NSString, UIImage>()
    let dataContainer = DataContainer.cache
    
    init(filename: String) {
        self.filename = filename
    }
    
    func load() -> UIImage? {
        if let img = cache.object(forKey: filename as NSString) {
            return img
        }
        guard let data = dataContainer.load(filename: filename) else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    func save(image: UIImage) -> Bool {
        cache.setObject(image, forKey: filename as NSString)
        
        guard let data = image.jpegData(compressionQuality: 0.95) else {
            print("Unable to load jpeg data representation")
            return false
        }
        
        return dataContainer.save(data: data, in: filename)
    }
}
