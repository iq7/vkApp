//
//  NewsfeedPostTypeCell.swift
//  vkApp
//
//  Created by Андрей Тихонов on 18.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

class NewsfeedPostTypeCell: UITableViewCell {
    
    var newsfeedTypePost: NewsfeedTypePost?
    
    let offset: CGFloat = 10.0
    let avatarSize: CGFloat = 50.0
    let iconSize: CGFloat = 20.0

    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.translatesAutoresizingMaskIntoConstraints = true
            avatar.frame = CGRect(origin: CGPoint(x: offset, y: offset), size: CGSize(width: avatarSize, height: avatarSize))
            AppWrapper.standard.makeBeauty(for: avatar, borderWidth: 1.0, borderColor: .avatarBorderColor)
        }
    }

    @IBOutlet weak var title: UILabel! {
        didSet {
            title.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var datePost: UILabel! {
        didSet {
            datePost.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var textPost: UILabel! {
        didSet {
            textPost.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var attachments: UIView! {
        didSet {
            attachments.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var likesCount: UILabel! {
        didSet {
            likesCount.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var likesImg: UIImageView! {
        didSet {
            likesImg.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var commentsCount: UILabel! {
        didSet {
            commentsCount.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var commentsImg: UIImageView! {
        didSet {
            commentsImg.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var repostCount: UILabel! {
        didSet {
            repostCount.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var repostImg: UIImageView! {
        didSet {
            repostImg.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var viewsCount: UILabel! {
        didSet {
            viewsCount.translatesAutoresizingMaskIntoConstraints = true
        }
    }

    @IBOutlet weak var viewsImg: UIImageView! {
        didSet {
            viewsImg.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        initCell(newsfeedTypePost)
    }

    func initCell(_ cell: NewsfeedTypePost?) {
        guard let cell = cell else { return }
        title.text = cell.title
        datePost.text = cell.datePostLocal
        textPost.text = cell.textPost

        likesCount.text = AppWrapper.standard.convertIntToStrigWithReduction(cell.likes.count)
        repostCount.text = AppWrapper.standard.convertIntToStrigWithReduction(cell.reposts.count)
        viewsCount.text = AppWrapper.standard.convertIntToStrigWithReduction(cell.views.count)
        commentsCount.text = AppWrapper.standard.convertIntToStrigWithReduction(cell.comments.count)

        likesImg.image = nil
        repostImg.image = nil
        viewsImg.image = nil
        commentsImg.image = nil
        avatar.image = nil
        
        initFrames(cell)
    }

    private func initFrames(_ cell: NewsfeedTypePost?) {
        let boundsWidth = UIScreen.main.bounds.width

        var heightCell: CGFloat = offset + offset

        // Считаем размеры и положение шапки (аватар, тайтл, дата)
        let avatarFrameSize = CGSize(width: avatarSize, height: avatarSize)

        let maxTitleWidth = boundsWidth - avatarFrameSize.width - offset * 3.0
        let maxDateWidth = maxTitleWidth
        
        let titleFrameSize = AppWrapper.standard.getLabelSize(text: title.text, font: title.font, maxWidth: maxTitleWidth)
        let datePostFrameSize = AppWrapper.standard.getLabelSize(text: datePost.text, font: datePost.font, maxWidth: maxDateWidth)

        var arrHeight = [avatarFrameSize.height, ceil(titleFrameSize.height + datePostFrameSize.height + offset / 2.0)]
        var maxHeight = AppWrapper.standard.findMax(arr: arrHeight)

        let avatarOffsetY = ceil((maxHeight - avatarFrameSize.height) / 2.0 + offset + offset)
        let avatarFrameOrigin = CGPoint(x: offset, y: avatarOffsetY)
        avatar.frame = CGRect(origin: avatarFrameOrigin, size: avatarFrameSize)
        
        let titleOffsetX = avatarFrameOrigin.x + avatarFrameSize.width + offset
        let titleOffsetY = ceil((maxHeight - titleFrameSize.height - offset - datePostFrameSize.height) / 2.0 + offset + offset)
        let titleFrameOrigin = CGPoint(x: titleOffsetX, y: titleOffsetY)
        title.frame = CGRect(origin: titleFrameOrigin, size: titleFrameSize)
        
        let datePostOffsetX = avatarFrameOrigin.x + avatarFrameSize.width + offset
        let datePostOffsetY = ceil(titleFrameOrigin.y + titleFrameSize.height + offset / 2.0)
        let datePostOrigin = CGPoint(x: datePostOffsetX, y: datePostOffsetY)
        datePost.frame = CGRect(origin: datePostOrigin, size: datePostFrameSize)

        heightCell += maxHeight + offset + offset

        // Считаем размеры и положение текста
        if let count = textPost.text?.count {
            if count > 0 {
                let maxTextPostWidth = boundsWidth - offset * 2.0
                let textPostFrameSize = AppWrapper.standard.getLabelSize(text: textPost.text, font: textPost.font, maxWidth: maxTextPostWidth)
                let textPostOrigin = CGPoint(x: offset, y: heightCell)
                textPost.frame = CGRect(origin: textPostOrigin, size: textPostFrameSize)
                heightCell += textPostFrameSize.height + offset + offset
            } else {
                textPost.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            }
        }

        // Считаем размеры и положение attachments
        for subview in attachments.subviews {
            subview.removeFromSuperview()
        }
        let maxAttachmentsWidth = boundsWidth - offset * 2.0
        let attachmentsFrameSize = CGSize(width: maxAttachmentsWidth, height: 0)
        let attachmentsOrigin = CGPoint(x: offset, y: heightCell)
        attachments.frame = CGRect(origin: attachmentsOrigin, size: attachmentsFrameSize)

        if let attachments = cell?.attachments {
            heightCell += calculateHeightAttachment(photos: attachments) + offset
        }

        // Считаем размеры и положение likes & etc
        var offsetX = offset
        let maxMetaWidth: CGFloat = ceil((boundsWidth - iconSize * 4 - offset * 9.0) / 4)
        
        let likesImgFrameSize = CGSize(width: iconSize, height: iconSize)
        let likesCountFrameSize = AppWrapper.standard.getLabelSize(text: likesCount.text, font: likesCount.font, maxWidth: maxMetaWidth)
        let commentsImgFrameSize = CGSize(width: iconSize, height: iconSize)
        let commentsCountFrameSize = AppWrapper.standard.getLabelSize(text: commentsCount.text, font: commentsCount.font, maxWidth: maxMetaWidth)
        let repostImgFrameSize = CGSize(width: iconSize, height: iconSize)
        let repostCountFrameSize = AppWrapper.standard.getLabelSize(text: repostCount.text, font: repostCount.font, maxWidth: maxMetaWidth)
        let viewsImgFrameSize = CGSize(width: iconSize, height: iconSize)
        let viewsCountFrameSize = AppWrapper.standard.getLabelSize(text: viewsCount.text, font: viewsCount.font, maxWidth: maxMetaWidth)

        arrHeight = [likesImgFrameSize.height, likesCountFrameSize.height,
                     commentsImgFrameSize.height, commentsCountFrameSize.height,
                     repostImgFrameSize.height, repostCountFrameSize.height,
                     viewsImgFrameSize.height, viewsCountFrameSize.height]
        maxHeight = AppWrapper.standard.findMax(arr: arrHeight)

        let likesImgOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - likesImgFrameSize.height) / 2.0 + heightCell))
        likesImg.frame = CGRect(origin: likesImgOrigin, size: likesImgFrameSize)
        offsetX += likesImgFrameSize.width + offset / 2.0

        let likesCountOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - likesCountFrameSize.height) / 2.0 + heightCell))
        likesCount.frame = CGRect(origin: likesCountOrigin, size: likesCountFrameSize)
        offsetX += likesCountFrameSize.width + offset * 2.0

        let commentsImgOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - commentsImgFrameSize.height) / 2.0 + heightCell))
        commentsImg.frame = CGRect(origin: commentsImgOrigin, size: commentsImgFrameSize)
        offsetX += ceil(commentsImgFrameSize.width + offset / 2.0)

        let commentsCountOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - commentsCountFrameSize.height) / 2.0 + heightCell))
        commentsCount.frame = CGRect(origin: commentsCountOrigin, size: commentsCountFrameSize)
        offsetX += commentsCountFrameSize.width + offset * 2.0

        let repostImgOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - repostImgFrameSize.height) / 2.0 + heightCell))
        repostImg.frame = CGRect(origin: repostImgOrigin, size: repostImgFrameSize)
        offsetX += ceil(repostImgFrameSize.width + offset / 2.0)

        let repostCountOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - repostCountFrameSize.height) / 2.0 + heightCell))
        repostCount.frame = CGRect(origin: repostCountOrigin, size: repostCountFrameSize)
        offsetX += repostCountFrameSize.width + offset * 2.0

        let viewsImgOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - viewsImgFrameSize.height) / 2.0 + heightCell))
        viewsImg.frame = CGRect(origin: viewsImgOrigin, size: viewsImgFrameSize)
        offsetX += ceil(viewsImgFrameSize.width + offset / 2.0)

        let viewsCountOrigin = CGPoint(x: offsetX, y: ceil((maxHeight - viewsCountFrameSize.height) / 2.0 + heightCell))
        viewsCount.frame = CGRect(origin: viewsCountOrigin, size: viewsCountFrameSize)
        offsetX += viewsCountFrameSize.width + offset * 2.0
        
        heightCell += maxHeight + offset + offset + 1.0
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
    
    func showImages(photos: [Photo], y: CGFloat) -> CGFloat {
        let photos = calculateProportionsOfImages(elements: photos)
        return y + CGFloat(photos[0].mHeight) + offset
    }

    func calculateHeightAttachment(photos: [Photo]) -> CGFloat {
        
        var y: CGFloat = 0.0
        switch photos.count {
        case 1:
            y = showImages(photos: [photos[0]], y: y)
            break
        case 2:
            y = showImages(photos: [photos[0], photos[1]], y: y)
            break
        case 3:
            y = showImages(photos: [photos[0]], y: y)
            y = showImages(photos: [photos[1], photos[2]], y: y)
            break
        case 4:
            y = showImages(photos: [photos[0]], y: y)
            y = showImages(photos: [photos[1], photos[2], photos[3]], y: y)
            break
        case 5:
            y = showImages(photos: [photos[0]], y: y)
            y = showImages(photos: [photos[1], photos[2], photos[3], photos[4]], y: y)
            break
        case 6:
            y = showImages(photos: [photos[0], photos[1]], y: y)
            y = showImages(photos: [photos[2], photos[3], photos[4], photos[5]], y: y)
            break
        case 7:
            y = showImages(photos: [photos[0]], y: y)
            y = showImages(photos: [photos[1], photos[2], photos[3]], y: y)
            y = showImages(photos: [photos[4], photos[5], photos[6]], y: y)
            break
        case 8:
            y = showImages(photos: [photos[0], photos[1]], y: y)
            y = showImages(photos: [photos[2], photos[3], photos[4]], y: y)
            y = showImages(photos: [photos[5], photos[6], photos[7]], y: y)
            break
        case 9:
            y = showImages(photos: [photos[0]], y: y)
            y = showImages(photos: [photos[1], photos[2], photos[3], photos[4]], y: y)
            y = showImages(photos: [photos[5], photos[6], photos[7], photos[8]], y: y)
            break
        case 10:
            y = showImages(photos: [photos[0], photos[1]], y: y)
            y = showImages(photos: [photos[2], photos[3], photos[4], photos[5]], y: y)
            y = showImages(photos: [photos[6], photos[7], photos[8], photos[9]], y: y)
            break
        default:
            break
        }
        return y
    }
}
