//
//  GroupListTableVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupListTableVC: UITableViewController {

    var notificationToken: NotificationToken?
    var groupList: Results<GroupProfile>?
    
    var photoService: PhotoService?

    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKService.getMyGroups(fields: [.members_count])
        photoService = PhotoService(container: tableView)
        pairTableAndRealm()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath) as? GroupListCell, let group = groupList?[indexPath.row] else {
            assertionFailure("Error")
            return UITableViewCell()
        }

        cell.initCell(group)
        let imageURL = group.photo50URL
        cell.avatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var maxHeight: CGFloat = 44.0
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell") as? GroupListCell,
            let group = groupList?[indexPath.row] else {
                assertionFailure("Error")
                return maxHeight
        }
        let boundsWidth = UIScreen.main.bounds.width

        let avatarFrameSize = CGSize(width: cell.avatarSize, height: cell.avatarSize)
        let maxWidth = boundsWidth - avatarFrameSize.width - cell.offsets * 3.0
        let titleFrameSize = AppWrapper.standard.getLabelSize(text: group.name, font: cell.title.font, maxWidth: maxWidth)
        let membersCountFrameSize = AppWrapper.standard.getLabelSize(text: String(group.membersCount), font: cell.membersCount.font, maxWidth: maxWidth)
        let arrHeight = [avatarFrameSize.height, titleFrameSize.height + membersCountFrameSize.height + cell.offsets / 2.0]
        maxHeight = AppWrapper.standard.findMax(arr: arrHeight) + cell.offsets * 2.0 + 1.0

        return maxHeight
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let group = groupList else { return }
            VKService.leaveGroupById(id: group[indexPath.row].id)
            updateTitle()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewGroup" else { return }
        VKService.joinGroupById(id: id)
        updateTitle()
    }
}

extension GroupListTableVC {
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groupList = realm.objects(GroupProfile.self)//.sorted(byKeyPath: "name")
        notificationToken = groupList?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .error(let error):
                fatalError("\(error)")
                break
            default:
                self?.updateTitle()
                tableView.reloadData()
            }
        }
    }
    
    func updateTitle() {
        var titleNavigation = "Группы"
        if let groupsCount = self.groupList?.count {
            titleNavigation += " (\(groupsCount))"
        }
        self.navigationItem.title = titleNavigation
    }
}
