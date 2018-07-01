//
//  Photo.swift
//  vkApp
//
//  Created by Андрей Тихонов on 19.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id = 0
    @objc dynamic var albumId = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var photo75URL = ""
    @objc dynamic var photo130URL = ""
    @objc dynamic var photo604URL = ""
    @objc dynamic var photo807URL = ""
    @objc dynamic var photo1280URL = ""
    @objc dynamic var photo2560URL = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var text = ""
    @objc dynamic var date = 0.0
    @objc dynamic var likesCount = 0
    @objc dynamic var userLikes = 0
    @objc dynamic var repostsCount = 0
    @objc dynamic var realOffset = 0
    @objc dynamic var mWidth = 0.0
    @objc dynamic var mHeight = 0.0

    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        albumId = json["album_id"].intValue
        ownerId = json["owner_id"].intValue
        photo75URL = json["photo_75"].stringValue
        photo130URL = json["photo_130"].stringValue
        photo604URL = json["photo_604"].stringValue
        photo807URL = json["photo_807"].stringValue
        photo1280URL = json["photo_1280"].stringValue
        photo2560URL = json["photo_2560"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
        text = json["text"].stringValue
        date = json["date"].doubleValue
        likesCount = json["likes"]["count"].intValue
        userLikes = json["likes"]["user_likes"].intValue
        repostsCount = json["reposts"]["count"].intValue
        realOffset = json["real_offset"].intValue
    }
}
