//
//  Model.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/17/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import Foundation

// make item type able to encode itself into plist or json, etc.
// all properties must have standard data types if using Encodable
// can replace Encodeable, Decodable with Codable
class Item: Codable {
    
    var title: String? = ""
    var done: Bool = false
    
    public init() {

    }
    
    
    
}
