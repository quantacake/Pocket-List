//
//  Item.swift
//  Pocket List
//
//  Created by ted diepenbrock on 8/20/19.
//  Copyright © 2019 ted diepenbrock. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var cellColor : String = ""
    
    // inverse relationship with Category. 'items' is property name of the inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
