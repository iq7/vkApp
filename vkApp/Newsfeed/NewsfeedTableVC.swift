//
//  NewsfeedTableVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 18.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsfeedTableVC: UITableViewController {
    
    var posts = [NewsfeedTypePost]()
    var photoService: PhotoService?
    let offset: CGFloat = 10.0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoService = PhotoService(container: tableView)

        guard let deviceID = UIDevice.current.identifierForVendor else {
            assertionFailure("Не удалось получить ID устройства.")
            return
        }
        print("-----------------")
        print(NSUUID().uuidString)
        print(deviceID.uuidString)
        print("-----------------")
        VKService.registerDevices(deviceID: deviceID.uuidString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VKService.getNewsfeed() { [weak self] posts in
            self?.posts = posts
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedPostTypeCell", for: indexPath) as? NewsfeedPostTypeCell else {
            assertionFailure("Error")
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        
        cell.initCell(post)
        let imageURL = post.avatarURL
        cell.avatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: imageURL)

        for subview in cell.attachments.subviews {
            subview.removeFromSuperview()
        }
        
        let _ = showAttachment(cell: cell, atIndexPath: indexPath, photos: post.attachments)
        
        cell.likesImg.image = UIImage(named: "heart")
        cell.commentsImg.image = UIImage(named: "about")
        cell.repostImg.image = UIImage(named: "advertising")
        cell.viewsImg.image = UIImage(named: "visible")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var heightCell: CGFloat = 44.0

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedPostTypeCell") as? NewsfeedPostTypeCell else {
            assertionFailure("Error")
            return heightCell
        }

        let newsfeedPost = posts[indexPath.row]
        
        let boundsWidth = UIScreen.main.bounds.width

        heightCell = cell.offset + cell.offset

        let avatarFrameSize = CGSize(width: cell.avatarSize, height: cell.avatarSize)
        let maxTitleWidth = boundsWidth - avatarFrameSize.width - cell.offset * 3.0
        let maxDateWidth = maxTitleWidth
        let titleFrameSize = AppWrapper.standard.getLabelSize(text: newsfeedPost.title, font: cell.title.font, maxWidth: maxTitleWidth)
        let datePostFrameSize = AppWrapper.standard.getLabelSize(text: newsfeedPost.datePostLocal, font: cell.datePost.font, maxWidth: maxDateWidth)
        
        var arrHeight = [avatarFrameSize.height, ceil(titleFrameSize.height + datePostFrameSize.height + cell.offset / 2.0)]
        var maxHeight = AppWrapper.standard.findMax(arr: arrHeight)
        
        heightCell += maxHeight + cell.offset + cell.offset

        if newsfeedPost.textPost.count > 0 {
            let maxTextPostWidth = boundsWidth - cell.offset * 2.0
            let textPostFrameSize = AppWrapper.standard.getLabelSize(text: newsfeedPost.textPost, font: cell.textPost.font, maxWidth: maxTextPostWidth)
            heightCell += textPostFrameSize.height + cell.offset + cell.offset
        }
        
        let maxAttachmentsWidth = boundsWidth - cell.offset * 2.0
        let attachmentsHeight = showAttachment(cell: cell, atIndexPath: indexPath, photos: newsfeedPost.attachments)
        let attachmentsFrameSize = CGSize(width: maxAttachmentsWidth, height: attachmentsHeight)
        heightCell += attachmentsFrameSize.height + cell.offset + cell.offset
        
        let maxMetaWidth: CGFloat = ceil((boundsWidth - cell.iconSize * 4 - cell.offset * 9.0) / 4)
        
        let likesCount = AppWrapper.standard.convertIntToStrigWithReduction(newsfeedPost.likes.count)
        let repostCount = AppWrapper.standard.convertIntToStrigWithReduction(newsfeedPost.reposts.count)
        let viewsCount = AppWrapper.standard.convertIntToStrigWithReduction(newsfeedPost.views.count)
        let commentsCount = AppWrapper.standard.convertIntToStrigWithReduction(newsfeedPost.comments.count)
        
        let likesImgFrameSize = CGSize(width: cell.iconSize, height: cell.iconSize)
        let likesCountFrameSize = AppWrapper.standard.getLabelSize(text: likesCount, font: cell.likesCount.font, maxWidth: maxMetaWidth)
        let commentsImgFrameSize = CGSize(width: cell.iconSize, height: cell.iconSize)
        let commentsCountFrameSize = AppWrapper.standard.getLabelSize(text: repostCount, font: cell.commentsCount.font, maxWidth: maxMetaWidth)
        let repostImgFrameSize = CGSize(width: cell.iconSize, height: cell.iconSize)
        let repostCountFrameSize = AppWrapper.standard.getLabelSize(text: viewsCount, font: cell.repostCount.font, maxWidth: maxMetaWidth)
        let viewsImgFrameSize = CGSize(width: cell.iconSize, height: cell.iconSize)
        let viewsCountFrameSize = AppWrapper.standard.getLabelSize(text: commentsCount, font: cell.viewsCount.font, maxWidth: maxMetaWidth)
        
        arrHeight = [likesImgFrameSize.height, likesCountFrameSize.height,
                     commentsImgFrameSize.height, commentsCountFrameSize.height,
                     repostImgFrameSize.height, repostCountFrameSize.height,
                     viewsImgFrameSize.height, viewsCountFrameSize.height]
        maxHeight = AppWrapper.standard.findMax(arr: arrHeight)
        
        heightCell += maxHeight + cell.offset + cell.offset + 1.0

        return heightCell
    }
    
    func calculateProportionsOfImages(elements: [Photo]) -> [Photo] {
        let boundsWidth = UIScreen.main.bounds.width - offset * 2
        var allWidth = 0.0
        for element in elements {
            let proportion = Double(elements[0].height) / Double(element.height)
            element.mWidth = Double(element.width) * proportion
            element.mHeight = Double(element.height) * proportion
            allWidth += element.mWidth
        }
        let proportion = Double(boundsWidth - offset * CGFloat(elements.count - 1)) / allWidth
        for element in elements {
            element.mWidth *= proportion
            element.mHeight *= proportion
        }
        return elements
    }
    
    func lineUpImages(cell: NewsfeedPostTypeCell, atIndexPath: IndexPath, photos: [Photo], y: CGFloat, size: Int = 0) {
        var x: CGFloat = 0.0
        var i = 0
        for photo in photos {

            var imageURL = ""
            switch photos.count {
            case 0:
                break
            case 1:
                imageURL = photos[i].photo604URL
                break
            case 2:
                imageURL = photos[i].photo604URL
                break
            case 3:
                imageURL = photos[i].photo130URL
                break
            case 4:
                imageURL = photos[i].photo75URL
                break
            default:
                imageURL = photos[i].photo604URL
            }
            let img = UIImageView()
            img.contentMode = .scaleToFill
            img.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: photo.mWidth, height: photo.mHeight))
            img.image = photoService?.photo(atIndexpath: atIndexPath, byUrl: imageURL)
            AppWrapper.standard.makeBeauty(for: img, borderWidth: 1.0, borderRadius: 5.0, borderColor: .avatarBorderColor)
            cell.attachments.addSubview(img)
            x += CGFloat(photo.mWidth) + offset
            i += 1
        }
    }

    func showImages(cell: NewsfeedPostTypeCell, atIndexPath: IndexPath, photos: [Photo], y: CGFloat) -> CGFloat {
        
        let photos = calculateProportionsOfImages(elements: photos)
        lineUpImages(cell: cell, atIndexPath: atIndexPath, photos: photos, y: y)
        return y + CGFloat(photos[0].mHeight) + offset
    }

    func showAttachment(cell: NewsfeedPostTypeCell, atIndexPath: IndexPath, photos: [Photo]) -> CGFloat {

        var y: CGFloat = 0.0
        switch photos.count {
        case 1:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            break
        case 2:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0], photos[1]], y: y)
            break
        case 3:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[1], photos[2]], y: y)
            break
        case 4:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[1], photos[2], photos[3]], y: y)
            break
        case 5:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[1], photos[2], photos[3], photos[4]], y: y)
            break
        case 6:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0], photos[1]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[2], photos[3], photos[4], photos[5]], y: y)
            break
        case 7:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[1], photos[2], photos[3]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[4], photos[5], photos[6]], y: y)
            break
        case 8:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0], photos[1]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[2], photos[3], photos[4]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[5], photos[6], photos[7]], y: y)
            break
        case 9:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[1], photos[2], photos[3], photos[4]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[5], photos[6], photos[7], photos[8]], y: y)
            break
        case 10:
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[0], photos[1]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[2], photos[3], photos[4], photos[5]], y: y)
            y = showImages(cell: cell, atIndexPath: atIndexPath, photos: [photos[6], photos[7], photos[8], photos[9]], y: y)
            break
        default:
            y = 0
            break
        }
        return y
    }
    
    @IBAction func sendMessagePressed(unwindSegue: UIStoryboardSegue) {
    }
}
