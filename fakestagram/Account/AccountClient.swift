//
//  AccountClient.swift
//  fakestagram
//
//  Created by Andrès Leal Giorguli on 4/26/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import Foundation

class AccountClient: RestClient<Account> {
    convenience init() {
        self.init(client: Client(), path: "/api/accounts")
    }
}
