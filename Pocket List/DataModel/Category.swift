//
//  Category.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/20/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor : String = ""
    
    // forward relationship with Item
    let items = List<Item>()
    
    
    
}
