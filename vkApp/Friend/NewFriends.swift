//
//  NewFriends.swift
//  vkApp
//
//  Created by Андрей Тихонов on 28.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewFriendProfile: Object {
    @objc dynamic var id = 0
    
    convenience init(json: JSON) {
        self.init()
        id = json["user_id"].intValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
