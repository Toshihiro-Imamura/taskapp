//
//  Category.swift
//  taskapp
//
//  Created by 今村俊博 on 2020/01/19.
//  Copyright © 2020 toshihiro.imamura. All rights reserved.
//

import RealmSwift

class Category: Object {
    @objc dynamic var categoryid = 0
    
    @objc dynamic var categoryname = ""
    
    override static func primaryKey() -> String? {
        return "categoryid"
    }
}
