//
//  VkServicePhoto.swift
//  vkApp
//
//  Created by Андрей Тихонов on 20.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {

    static func getListPhotos(ownerId: Int) {
        var parameters: Parameters = ["v": "5.73", "access_token": token]
        parameters["owner_id"] = ownerId
        let url = baseUrl + "/method/photos.getAll"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            guard
                let data = response.value,
                let json = try? JSON(data: data)
                else { return }
            let photos = json["response"]["items"].compactMap { Photo(json: $0.1) }
            savePhotos(photos, ownerId: ownerId)
        }
    }

    static func savePhotos(_ photos: [Photo], ownerId: Int) {
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(Photo.self).filter("ownerId == %@", ownerId)
            try realm.write{
                realm.delete(oldPhotos)
                realm.add(photos)
            }
        } catch {
            print(error)
        }
    }
}
