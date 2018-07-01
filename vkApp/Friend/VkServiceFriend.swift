//
//  VkServiceFriend.swift
//  vkApp
//
//  Created by Андрей Тихонов on 11.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {
    static func getMyFrends(fields: [fieldsListFrends]) {
        var parameters: Parameters = ["v": "5.8", "access_token": token]
        let strFields = getStringFromArray(fields)
        if strFields != "" { parameters["fields"] = strFields }
        let url = baseUrl + "/method/friends.get"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else { return }
            let friendsProfile = json["response"]["items"].compactMap { FriendProfile(json: $0.1) }
            saveFriendProfile(friendsProfile)
        }
    }

    static func saveFriendProfile(_ friend: [FriendProfile]) {
        do {
            let realm = try Realm()
            let oldFriend = realm.objects(FriendProfile.self)
            try realm.write{
                realm.delete(oldFriend)
                realm.add(friend)
            }
        } catch {
            print(error)
        }
    }
    
    static func getRequestsFriends(completion: @escaping ((Int?) -> Void)) -> DataRequest {
        
        var parameters: Parameters = ["v": "5.78", "access_token": token]
        parameters["extended"] = 1
        parameters["need_mutual"] = 0
        parameters["out"] = 0
        parameters["need_viewed"] = 0 // 1 вернет количество подписчиков
        parameters["suggested"] = 0
        let url = baseUrl + "/method/friends.getRequests"
        return Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else {
                    completion(nil)
                    return
            }
            let newFriends = json["response"]["items"].compactMap { NewFriendProfile(json: $0.1) }
            saveNewFriends(newFriends)
            completion(newFriends.count)
        }
    }
    
    static func saveNewFriends(_ newFriends: [NewFriendProfile]) {
        do {
            let realm = try Realm()
            let oldFriends = realm.objects(NewFriendProfile.self)
            try realm.write{
                realm.delete(oldFriends)
                realm.add(newFriends)
            }
        } catch {
            print(error)
        }
    }
}
