//
//  FriendsListTableVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 10.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsListTableVC: UITableViewController {

    var notificationToken: NotificationToken?
    var friendList: Results<FriendProfile>?

    var photoService: PhotoService?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKService.getMyFrends(fields: [.nickname, .photo_50, .last_seen])
        photoService = PhotoService(container: tableView)
        pairTableAndRealm()
        
        
        guard let deviceID = UIDevice.current.identifierForVendor else {
            assertionFailure("Не удалось получить ID устройства.")
            return
        }
        VKService.getPushSettings(deviceID: deviceID.uuidString)
        

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendList", for: indexPath) as? FriendsListCell else {
            assertionFailure("Error")
            return UITableViewCell()
        }
        
        if let friend = friendList?[indexPath.row] {
            cell.initCell(friend)
            let imageURL = friend.photo50URL
            cell.avatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var maxHeight: CGFloat = 44.0

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendList") as? FriendsListCell,
            let friend = friendList?[indexPath.row] else {
                assertionFailure("Error")
                return maxHeight
        }

        let boundsWidth = UIScreen.main.bounds.width

        let avatarFrameSize = CGSize(width: cell.avatarSize, height: cell.avatarSize)
        let onlineFrameSize = CGSize(width: cell.onlineSize, height: cell.onlineSize)
        let maxWidth = boundsWidth - avatarFrameSize.width - onlineFrameSize.width - cell.offsets * 4.0
        let nameFrameSize = AppWrapper.standard.getLabelSize(text: friend.name, font: cell.title.font, maxWidth: maxWidth)
    
        let arrHeight = [avatarFrameSize.height, onlineFrameSize.height, nameFrameSize.height]
        maxHeight = AppWrapper.standard.findMax(arr: arrHeight) + cell.offsets * 2.0 + 1.0

        return maxHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "toPhotoAlbum",
            let destinationVC = segue.destination as? photoFriendsCollectionVC,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let friendId = friendList?[indexPath.row].id
        else {
            assertionFailure()
            return
        }
        print("friendId: \(friendId)")
        destinationVC.ownerId = friendId
    }

    @IBAction func donePhotoalbumPressed(unwindSegue: UIStoryboardSegue) {
    }
}

extension FriendsListTableVC {
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friendList = realm.objects(FriendProfile.self).sorted(byKeyPath: "lastName")
        notificationToken = friendList?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .error(let error):
                fatalError("\(error)")
                break
            default:
                tableView.reloadData()
            }
        }

        var titleNavigation = "Друзья"
        if let friendsCount = self.friendList?.count {
            titleNavigation += " (\(friendsCount))"
        }
        self.navigationItem.title = titleNavigation
    }
}
