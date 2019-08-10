//
//  UIImage+encodedBase64.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 4/27/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func encodedBase64() -> String?{
        guard let data = self.jpegData(compressionQuality: 0.95) else{return nil}
        return "data:image/jpeg;base64,\(data.base64EncodedString())"
    }
}
