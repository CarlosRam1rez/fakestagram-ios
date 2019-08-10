//
//  Like.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 5/25/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

struct Like: Codable {
    let author: Author?
    let createdAt: String
    let updatedAt: String
}
