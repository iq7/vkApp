//
//  VkServiceNewsfeed.swift
//  vkApp
//
//  Created by Андрей Тихонов on 18.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {
    
    static func getNewsfeed(userToken: String = token, count: Int = 50, completion: @escaping ([NewsfeedTypePost]) -> Void) {
        
        let parameters: Parameters = ["filters" : "post", "count" : count, "v": "5.60", "access_token": userToken]
        let url = baseUrl + "/method/newsfeed.get"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            if let data = response.value, let json = try? JSON(data: data) {
                var profilesWithId = [Int: FriendProfile]()
                let profiles = json["response"]["profiles"].compactMap { FriendProfile(json: $0.1) }
                for profile in profiles { profilesWithId[profile.id] = profile }
            
                var groupsWithId = [Int: GroupProfile]()
                let groups = json["response"]["groups"].compactMap { GroupProfile(json: $0.1) }
                for group in groups { groupsWithId[group.id] = group }
            
                var posts: [NewsfeedTypePost] = []
            
                for (index, _) in json["response"]["items"].enumerated() {
                    if json["response"]["items"][index]["type"] == "post" {
                        let post = NewsfeedTypePost(json: json["response"]["items"][index])
                        let sourceId = post.sourceId
                        if sourceId > 0 {
                            post.avatarURL = profilesWithId[sourceId]?.photo50URL ?? ""
                            post.title = profilesWithId[sourceId]?.name ?? "Секретный агент"
                        } else {
                            post.avatarURL = groupsWithId[0 - sourceId]?.photo50URL ?? ""
                            post.title = groupsWithId[0 - sourceId]?.name ?? "Секретная организация"
                        }
                        posts.append(post)
                    }
                }
                DispatchQueue.main.async {
                    completion(posts)
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}
