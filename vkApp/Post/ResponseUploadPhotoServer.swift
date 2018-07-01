//
//  ResponseUploadPhotoServer.swift
//  vkApp
//
//  Created by Андрей Тихонов on 01.07.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResponseUploadPhotoServer {
    
    var uploadUrl: String
    var albumId: Int
    var userId: Int

    init(url: String = "", album: Int = 0, user: Int = 0) {
        uploadUrl = url
        albumId = album
        userId = user
    }
    init(json: JSON) {
        uploadUrl = json["upload_url"].stringValue
        albumId = json["album_id"].intValue
        userId = json["user_id"].intValue
    }
}
