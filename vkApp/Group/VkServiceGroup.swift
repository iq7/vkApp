//
//  VkServiceGroup.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import Firebase

extension VKService {
    
    static func getMyGroups(fields: [fieldsListGroups]) {
        var parameters: Parameters = ["extended": 1, "v": "5.61", "access_token": token]
        parameters["fields"] = getStringFromArray(fields)
        let url = baseUrl + "/method/groups.get"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
            else { return }
            let groupsProfile = json["response"]["items"].compactMap { GroupProfile(json: $0.1) }
            saveGroups(groupsProfile)
        }
    }

    static func saveGroups(_ groups: [GroupProfile]) {
        do {
            let realm = try Realm()
            let oldGroup = realm.objects(GroupProfile.self)
            try realm.write{
                realm.delete(oldGroup)
                realm.add(groups)
            }
        } catch {
            print(error)
        }
    }
    
    static func joinGroupById(id: Int) {
        var parameters: Parameters = ["v": "5.74", "access_token": token]
        parameters["group_id"] = id
        let url = baseUrl + "/method/groups.join"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
            else { return }
            if json["response"] == 1 { saveJoinGroup(id) }
        }
    }

    static func saveJoinGroup(_ id: Int) {
        VKService.getMyGroups(fields: [.members_count])

        let timeStamp = Array(String(NSDate().timeIntervalSince1970)).reduce("") { $1 == "." ? $0 : "\($0)\($1)" }
        let dbLink = Database.database().reference()
        dbLink.child("Users/\(userId)/joinGroup/\(timeStamp)").setValue(id)
    }

    static func leaveGroupById(id: Int) {
        var parameters: Parameters = ["v": "5.74", "access_token": token]
        parameters["group_id"] = id
        let url = baseUrl + "/method/groups.leave"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else { return }
            if json["response"] == 1 { saveLeaveGroup(id) }
        }
    }

    static func saveLeaveGroup(_ id: Int) {
        do {
            let realm = try Realm()
            let leaveGroup = realm.objects(GroupProfile.self).filter("id == %@", id)
            try realm.write{
                realm.delete(leaveGroup)
            }

            let timeStamp = Array(String(NSDate().timeIntervalSince1970)).reduce("") { $1 == "." ? $0 : "\($0)\($1)" }
            let dbLink = Database.database().reference()
            dbLink.child("Users/\(userId)/leaveGroup/\(timeStamp)").setValue(id)

        } catch {
            print(error)
        }
    }
}
