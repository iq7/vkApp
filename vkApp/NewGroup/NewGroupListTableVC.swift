//
//  NewGroupListTableVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

class NewGroupListTableVC: UITableViewController {
    
    var newGroupList = [GroupProfile]()
    let searchBar = UISearchBar()

    var photoService: PhotoService?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        
        VKService.getCatalogGroups() { [weak self] groupList in
            self?.newGroupList = groupList
            self?.tableView.reloadData()
        }
        photoService = PhotoService(container: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGroupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupListCell", for: indexPath) as? NewGroupListCell else {
            assertionFailure("Error")
            return UITableViewCell()
        }
        
        cell.initCell(newGroupList[indexPath.row])
        let imageURL = newGroupList[indexPath.row].photo50URL
        cell.avatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var maxHeight: CGFloat = 10.0
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupListCell") as? NewGroupListCell else {
            assertionFailure("Error")
            return maxHeight
        }

        let group = newGroupList[indexPath.row]
        
        let boundsWidth = UIScreen.main.bounds.width

        let avatarFrameSize = CGSize(width: cell.avatarSize, height: cell.avatarSize)
        let maxWidth = boundsWidth - avatarFrameSize.width - cell.offsets * 3.0
        let titleFrameSize = AppWrapper.standard.getLabelSize(text: group.name, font: cell.title.font, maxWidth: maxWidth)
        let membersCountFrameSize = AppWrapper.standard.getLabelSize(text: String(group.membersCount), font: cell.descriptionType.font, maxWidth: maxWidth)
        let arrHeight = [avatarFrameSize.height, titleFrameSize.height + membersCountFrameSize.height + cell.offsets / 2.0]
        maxHeight = AppWrapper.standard.findMax(arr: arrHeight) + cell.offsets * 2.0 + 1.0
        
        return maxHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGroup", let cell = sender as? UITableViewCell {
            guard let destinationVC = segue.destination as? GroupListTableVC else { return }
            if let indexPath = tableView.indexPath(for: cell) {
                destinationVC.id = newGroupList[indexPath.row].id
            }
        }
    }
}

extension NewGroupListTableVC: UISearchBarDelegate {

    func initSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchBar.endEditing(true)
            tableView.reloadData()
        } else {
            VKService.searchGroups(q: searchText.lowercased()) { [weak self] groupList in
                self?.newGroupList = groupList
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
