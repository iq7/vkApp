//
//  VkServiceMessage.swift
//  vkApp
//
//  Created by Андрей Тихонов on 28.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {

    static func unreadMessagesCount(completion: @escaping (Int?) -> Void) -> DataRequest {
        
        var parameters: Parameters = ["v": "5.78", "access_token": token]
        parameters["count"] = 200
        parameters["unread"] = 1
        parameters["important"] = 0
        parameters["unanswered"] = 0
        let url = baseUrl + "/method/messages.getDialogs"
        return Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else {
                    completion(nil)
                    return
            }
            let unreadMessages = json["response"]["items"].compactMap { UnreadMessages(json: $0.1) }
            var countUnreadMessage = 0
            for unreadMessage in unreadMessages {
                countUnreadMessage += unreadMessage.unread
            }
            completion(countUnreadMessage)
        }
    }
}
