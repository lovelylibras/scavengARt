//
//  Hunts.swift
//  scavengARt
//
//  Created by Rachel on 7/11/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation

//Hunt Model

struct Game: Decodable {
    let createdAt: String
    let updatedAt: String
    let hunt: Hunt
}

struct NewGame: Decodable {
    let createdAt: String
    let updatedAt: String
    let huntId: String
}
