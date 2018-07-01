//
//  FriendProfile.swift
//  vkApp
//
//  Created by Андрей Тихонов on 10.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class FriendProfile: Object {
    @objc dynamic var id = 0
    @objc dynamic var online = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var name = ""
    @objc dynamic var deactivated = "" // поле возвращается, если страница пользователя удалена или заблокирована, содержит значение deleted или banned. В этом случае опциональные поля не возвращаются.
    @objc dynamic var hidden = 0 // возвращается 1 при вызове без access_token, если пользователь установил настройку «Кому в интернете видна моя страница» — «Только пользователям ВКонтакте». В этом случае опциональные поля не возвращаются.
    @objc dynamic var sex = 0
    @objc dynamic var photo50URL = ""
    @objc dynamic var photo100URL = ""
    @objc dynamic var screenName = ""
    @objc dynamic var lastSeen = 0

    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        let onlineJson = json["online"].intValue
        online = onlineJson
        if online == 1 {
            lastSeen = json["last_seen"]["platform"].intValue
        }
        let firstNameJson = json["first_name"].stringValue
        let lastNameJson = json["last_name"].stringValue
        firstName = firstNameJson
        lastName = lastNameJson
        let separator = (firstNameJson.count > 0 && lastNameJson.count > 0) ? " " : ""
        name = firstName + separator + lastName
        deactivated = json["deactivated"].stringValue
        hidden = json["hidden"].intValue
        self.sex = json["sex"].intValue
        photo50URL = json["photo_50"].stringValue
        photo100URL = json["photo_medium_rec"].stringValue
        screenName = json["screen_name"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
