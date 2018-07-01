//
//  Messages.swift
//  vkApp
//
//  Created by Андрей Тихонов on 28.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class UnreadMessages: Object {
    @objc dynamic var unread = 0
    @objc dynamic var message = ""
    @objc dynamic var inRead = 0
    @objc dynamic var outRead = 0
    
    convenience init(json: JSON) {
        self.init()
        unread = json["unread"].intValue
        message = json["message"].stringValue
        inRead = json["in_read"].intValue
        outRead = json["out_read"].intValue
    }
}
