//
//  NewsfeedTypePost.swift
//  vkApp
//
//  Created by Андрей Тихонов on 18.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsfeedTypePost {
    
    var title: String = ""
    var avatarURL: String = ""
    var type: String                // post
    var sourceId: Int               // source_id -45353280
    var datePost: Double                // 1525079525
    var postId: Int                 // post_id 101199
    var postType: String            // post_type post
    var textPost: String                // Приятная встреча
    var signerId: Int               // signer_id 293721921
    var markedAsAds: Int            // marked_as_ads 0
    var attachments: [Photo] = []   // тут нужен массив разных классов
    var postSource: PostSourse        // [post_source]
    var comments: Comments
    var likes: Likes
    var reposts: Reposts
    var views: Views
    

    var datePostLocal: String = ""
    
    init(json: JSON) {
        type = json["type"].stringValue
        sourceId = json["source_id"].intValue
        let datePost = json["date"].doubleValue
        self.datePost = datePost
        postId = json["post_id"].intValue
        postType = json["post_type"].stringValue
        textPost = json["text"].stringValue
        signerId = json["signer_id"].intValue
        markedAsAds = json["marked_as_ads"].intValue
        postSource = PostSourse(type: json["post_source"]["type"].stringValue, platform: json["post_source"]["platform"].stringValue)
        comments = Comments(count: json["comments"]["count"].intValue, canPost: json["comments"]["can_post"].intValue)
        likes = Likes(count: json["likes"]["count"].intValue, userLikes: json["likes"]["user_likes"].intValue, canLike: json["likes"]["can_like"].intValue, canPublish: json["likes"]["can_ublish"].intValue)
        reposts = Reposts(count: json["reposts"]["count"].intValue, userReposted: json["reposts"]["user_reposted"].intValue)
        views = Views(count: json["views"]["count"].intValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        let date = Date(timeIntervalSince1970: TimeInterval(datePost))
        datePostLocal = dateFormatter.string(from: date)
 
        self.attachments.removeAll()
        
        let attachments = json["attachments"].compactMap { Attachments(json: $0.1) }
        for attachment in attachments {
            if let type = attachment.type, let json = attachment.json {
                if type == "photo" || type == "album" {
                    self.attachments.append(Photo(json: json))
                }
            }
        }
    }
}

class Attachments {
    var type: String? = nil
    var json: JSON? = nil
    init(json: JSON) {
        type = json["type"].stringValue
        switch type {
        case "photo":
            self.json = json["photo"]
            break
        case "album":
            self.json = json["album"]["thumb"]
            break
        default:
            break
        }
    }
}
