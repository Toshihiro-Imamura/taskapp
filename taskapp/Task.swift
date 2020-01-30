//
//  Task.swift
//  taskapp
//
//  Created by 今村俊博 on 2020/01/15.
//  Copyright © 2020 toshihiro.imamura. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0

    
    @objc dynamic var title = ""

    
    @objc dynamic var contents = ""

    
    @objc dynamic var date = Date()
    
    
    @objc dynamic var category = ""

    
    override static func primaryKey() -> String? {
        return "id"
    }
}
