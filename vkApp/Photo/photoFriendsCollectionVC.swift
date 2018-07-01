//
//  photoFriendsCollectionVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 20.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class photoFriendsCollectionVC: UICollectionViewController {

    var titleCollection = String()
    var ownerId = 0
    var photoCollection: Results<Photo>?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.title = titleCollection
        VKService.getListPhotos(ownerId: ownerId)

        pairTableAndRealm()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendPhotoCell", for: indexPath) as! photoFriendCollectionCell
        
        guard let photos = photoCollection else { return cell }
        let imageURL = photos[indexPath.row].photo130URL
        guard let url = URL(string: imageURL) else { return cell }
        guard let data = try? Data(contentsOf: url) else { return cell }
        cell.photo.image = UIImage(data: data)
        
        return cell
    }

    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        photoCollection = realm.objects(Photo.self).filter("ownerId == %@", ownerId)
        guard let photos = photoCollection else { return }
        notificationToken = photos.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                }, completion: nil)
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}
