//
//  LikesRepostsViewsEtcStuct.swift
//  vkApp
//
//  Created by Андрей Тихонов on 18.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Foundation

struct Likes {
    var count = 0           // число пользователей, которым понравилась запись
    var userLikes = 0      // наличие отметки «Мне нравится» от текущего пользователя (1 — есть, 0 — нет),
    var canLike = 0        // может ли пользователь поставить отметку «Мне нравится» (1 — может, 0 — не может)
    var canPublish = 0     // может ли пользователь сделать репост записи (1 — может, 0 — не может)
}

struct Reposts {
    var count = 0          // число пользователей, сделавших репост
    var userReposted = 0  // наличие репоста от текущего пользователя (0 — нет, 1 — есть)
}

struct Comments {
    var count = 0          // количество комментариев,
    var canPost = 0       // может ли пользователь комментировать запись (1 — может, 0 — не может);
}

struct Views {
    var count = 0          // количество комментариев,
}

struct PostSourse {
    var type = ""        // api
    var platform = ""    // iphone
}
