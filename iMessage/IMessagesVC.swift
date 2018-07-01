//
//  IMessagesVC.swift
//  iMessage
//
//  Created by Андрей Тихонов on 22.06.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import Messages
import SwiftKeychainWrapper

class IMessagesVC: MSMessagesAppViewController {

    @IBOutlet weak var tableView: UITableView!

    var photoService: PhotoService?
    var posts = [NewsfeedTypePost]()

    override func viewDidLoad() {
        super.viewDidLoad()

        photoService = PhotoService(container: tableView)
        
        let keychain = KeychainWrapper(serviceName: "group.pixeltron.org.vkApp", accessGroup: "group.pixeltron.org.vkApp")
        guard
            let token = keychain.string(forKey: "vkToken")
        else {
            print("\nНеобходимо пройти авторизацию в основном приложении\n")
            return
        }

        VKService.getNewsfeed(userToken: token, count: 25) { [weak self] posts in
            self?.posts = posts
            self?.tableView.reloadData()
        }
    }
}

extension IMessagesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "iMessageCell", for: indexPath) as? IMessageCell else {
            assertionFailure("iMessageCell error")
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        let avatarURL = post.avatarURL
        cell.avatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: avatarURL)
        cell.title.text = post.title
        cell.newsfeedText.text = post.textPost
        if
            let imageURL = post.attachments.first?.photo604URL,
            let image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL) {
            cell.avatar.image = image
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]

        let layout = MSMessageTemplateLayout()

        if
            let imageURL = post.attachments.first?.photo604URL,
            let image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL) {

            layout.image = image
        }
        
        layout.imageTitle = post.title
        layout.caption = post.textPost
        
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
}
