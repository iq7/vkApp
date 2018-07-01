//
//  VkServiceNewGroup.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {
    
    static func getCatalogGroups(completion: @escaping ([GroupProfile]) -> Void) {
        
        let parameters: Parameters = ["v": "5.73", "access_token": token]
        let url = baseUrl + "/method/groups.getCatalog"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) {
            response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else {
                    DispatchQueue.main.async { completion([]) }
                    return
            }
            
            let groups = json["response"]["items"].compactMap { GroupProfile(json: $0.1) }
            DispatchQueue.main.async { completion(groups) }
        }
    }

    static func searchGroups(q: String, completion: @escaping ([GroupProfile]) -> Void) {
        
        let parameters: Parameters = ["q": q, "sort": 0, "v": "5.73", "access_token": token]
        let url = baseUrl + "/method/groups.search"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) {
            response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
            else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            let groups = json["response"]["items"].compactMap { GroupProfile(json: $0.1) }
            DispatchQueue.main.async { completion(groups) }
        }
    }
}
