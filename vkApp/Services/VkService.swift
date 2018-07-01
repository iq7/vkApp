//
//  VkService.swift
//  vkApp
//
//  Created by Андрей Тихонов on 06.04.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

struct VKService {
    private init(){}
    
    static let baseUrl = "https://api.vk.com"
    static var token = ""
    static var userId = ""
    static var devToken = ""

    static func getStringFromArray(_ arr: [Any]) -> String {
        var str = ""
        for a in arr { str = str + String(describing: a) + "," }
        str.removeLast()
        return str
    }

    static func authVK(userID: Int) -> URLRequest{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: String(userID)),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "messages,friends,photos,groups,offline,wall"),//notifications,notify"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: components.url!)
        return request
    }

    static func getPushSettings(deviceID: String) {
        let parameters: Parameters = ["device_id": deviceID, "v": "5.80", "access_token": token]
        let url = baseUrl + "/method/account.getPushSettings"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
        }
    }

    static func registerDevices(deviceID: String) {
        let settins = "{\"msg\":\"on\",\"chat\":\"on\",\"friend\":\"on\",\"friend_found\":\"on\",\"friend_accepted\":\"on\",\"reply\":\"on\",\"comment\":\"on\",\"mention\":\"on\",\"like\":\"on\",\"repost\":\"on\",\"wall_post\":\"on\",\"wall_publish\":\"on\",\"group_invite\":\"on\",\"group_accepted\":\"on\",\"event_soon\":\"on\"}"

        let parameters: Parameters = ["settings": settins, "device_id": deviceID, "token": devToken, "v": "5.80", "access_token": token]
        let url = baseUrl + "/method/account.registerDevice"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
        }
    }
}
