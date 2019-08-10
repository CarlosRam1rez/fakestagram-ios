//
//  Account.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 5/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation
import UIKit

struct Account: Codable {
    let id: String?
    let name: String
    let deviceNumber: String
    let deviceModel: String
    
    static func initialize() -> Account {
        return Account(
            id: nil,
            name: Names.load().generate(),
            deviceNumber: UIDevice.identifier,
            deviceModel: UIDevice.modelName
        )
    }
    
    func toAuthor() -> Author {
        return Author(id: id ?? "12345", name: name)
    }
}
