//
//  GroupProfile.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class GroupProfile: Object {
    
    @objc dynamic var id = 0            // идентификатор сообщества
    @objc dynamic var name = "Секретная группа"     // название сообщества
    @objc dynamic var screenName = ""   // короткий адрес, например, apiclub
    @objc dynamic var isClosed = 0      // 0 — открытое сообщество; 1 — закрытое; 2 — частное
    @objc dynamic var deactivated = ""  // deleted — сообщество удалено; banned — заблокировано;
    @objc dynamic var isAdmin = 0       // 1 — текущий пользователь является руководителем; 0 — не является.
    @objc dynamic var adminLevel = 0    // если is_admin = 1 уровень полномочий текущего пользователя:
    // 1 — модератор;  2 — редактор; 3 — администратор.
    @objc dynamic var isMember = 0      // 1 — текущий пользователь является участником; 0 — не является.
    // @objc dynamic var invited_by = 0
    // идентификатор пользователя, который отправил приглашение в сообщество.
    // Поле возвращается только для метода groups.getInvites.
    @objc dynamic var type = ""         // тип сообщества:
    // (group — группа; page — публичная страница; event — мероприятие.)
    @objc dynamic var photo50URL = ""   // photo_50 URL главной фотографии с размером 50x50px.
    @objc dynamic var photo100URL = ""  // photo_100 URL главной фотографии с размером 100х100px.
    @objc dynamic var photo200URL = ""  // photo_200 URL главной фотографии в максимальном размере.
    @objc dynamic var membersCount = 0
    @objc dynamic var descriptionType = ""

    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        name = json["name"].stringValue
        screenName = json["screen_name"].stringValue
        let isClosed = json["is_closed"].intValue
        self.isClosed = isClosed
        deactivated = json["deactivated"].stringValue
        isAdmin = json["is_admin"].intValue
        adminLevel = json["admin_level"].intValue
        isMember = json["is_member"].intValue
        let type = json["type"].stringValue
        self.type = type
        photo50URL = json["photo_50"].stringValue
        photo100URL = json["photo_50"].stringValue
        photo200URL = json["photo_200"].stringValue
        membersCount = json["members_count"].intValue
        
        var descriptionType = ""

        switch isClosed {
        case 0:
            descriptionType = "Открыт"
            break
        case 1:
            descriptionType = "Закрыт"
            break
        case 2:
            descriptionType = "Частн"
            break
        default:
            print("GroupProfile: Не известное значение isClosed")
        }

        if descriptionType != "" {
            switch type {
            case "group":
                descriptionType += "ое сообщество"
                break
            case "page":
                descriptionType += "ая страница"
                break
            case "event":
                descriptionType += "ое мероприятие"
                break
            default:
                descriptionType = "Информация засекречена!"
                print("GroupProfile: Не известное значение type")
            }
        } else {
            descriptionType = "Информация засекречена!"
        }
        self.descriptionType = descriptionType
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
