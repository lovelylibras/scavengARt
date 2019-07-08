//
//  ErrorResponse.swift
//  scavengARt
//
//  Created by Rachel on 7/7/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    let error: String
    
    var errorDescription: String? {return error}
}


