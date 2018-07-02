//
//  VkServicePost.swift
//  vkApp
//
//  Created by Андрей Тихонов on 25.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

extension VKService {
    
    static func addPost(message: String) {
        var parameters: Parameters = ["v": "5.78", "access_token": token]
        parameters["message"] = message
        let url = baseUrl + "/method/wall.post"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
        }
    }
    
    static func getWallUploadServer(completion: @escaping (ResponseUploadPhotoServer?) -> Void) {
        let parameters: Parameters = ["v": "5.80", "access_token": token]
        let url = baseUrl + "/method/photos.getWallUploadServer"
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            if let data = response.value, let json = try? JSON(data: data) {
                let responseUploadPhotoServer = ResponseUploadPhotoServer(json: json["response"])
                DispatchQueue.main.async {
                    completion(responseUploadPhotoServer)
                    print("--------------responseUploadPhotoServer-----------------")
                    print("\(responseUploadPhotoServer.userId)")
                    print("\(responseUploadPhotoServer.albumId)")
                    print("\(responseUploadPhotoServer.uploadUrl)")
                    print("-------------------------------")
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    static func savePhoto(photo: String, server: String, hash: String, completion: @escaping (String) -> Void) {
        let parameters: Parameters = ["photo": photo, "server": server, "hash": hash, "v": "5.80", "access_token": token]
        let url = baseUrl + "/method/photos.saveWallPhoto"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global()) { response in
            if let data = response.value, let json = try? JSON(data: data) {
                DispatchQueue.main.async {
                    completion("photo\(json["response"][0]["owner_id"].stringValue)_\(json["response"][0]["id"].stringValue)")
                }
            } else {
                DispatchQueue.main.async {
                    completion("")
                }
            }
        }
    }
    
    private static func convertStringToData(_ string: String) -> Data {
        guard let dataString = String(string).data(using: String.Encoding.utf8, allowLossyConversion: true) else { return Data() }
        return dataString
    }
    
    static func uploadImageRequest(serverUrl: String, image: UIImage) {
        guard
            let serverUrl = NSURL(string: serverUrl) as URL?,
            let imageData = UIImageJPEGRepresentation(image, 0.6)
        else { return }

        let request = NSMutableURLRequest(url: serverUrl)
        let mutableData = NSMutableData();
        let boundary = NSUUID().uuidString
        mutableData.append(self.convertStringToData("--Boundary-\(boundary)\r\nContent-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\nContent-Type: image/jpg\r\n\r\n"))
        mutableData.append(imageData)
        mutableData.append(self.convertStringToData("\r\n--Boundary-\(boundary)\r\n"))

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=Boundary-\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = mutableData as Data
        print("-------- imageData -----------")
        print(imageData)
        print("------------------------------")

        let task = URLSession.shared.dataTask(with: request as URLRequest) { optionalData, response, error in

            if error != nil {
                print(error ?? "что-то пошло не так")
                return
            }

            do {
                guard
                    let unwrapData = optionalData,
                    let data = try JSONSerialization.jsonObject(with: unwrapData, options: []) as? NSDictionary
                else { return }
                
                let json = JSON(data)
                print("\n--------\njson: \(json)")

                VKService.savePhoto(photo: json["photo"].stringValue, server: json["server"].stringValue, hash: json["hash"].stringValue) { completion in
                    print("-------- savePhoto -----------")
                    print("\(completion)")
                    print("------------------------------")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
