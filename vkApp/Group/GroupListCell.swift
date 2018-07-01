//
//  GroupListCell.swift
//  vkApp
//
//  Created by Андрей Тихонов on 14.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.frame = CGRect(origin: CGPoint(x: offsets, y: offsets), size: CGSize(width: avatarSize, height: avatarSize))
            AppWrapper.standard.makeBeauty(for: avatar, borderWidth: 1.0, borderColor: .avatarBorderColor)
        }
    }
    
    @IBOutlet weak var title: UILabel! {
        didSet {
            title.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var membersCount: UILabel! {
        didSet {
            membersCount.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var group: GroupProfile?

    let offsets: CGFloat = 10.0
    let avatarSize: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initCell(group)
    }

    func initCell(_ cell: GroupProfile?) {
        guard let cell = cell else { return }
        title.text = cell.name
        membersCount.text = "Участников: \(cell.membersCount)"
        avatar.image = nil

        initFrames()
    }
    
    private func initFrames() {
        let boundsWidth = UIScreen.main.bounds.width

        let avatarFrameSize = CGSize(width: avatarSize, height: avatarSize)

        let maxWidth = boundsWidth - avatarFrameSize.width - offsets * 3.0
        let titleFrameSize = AppWrapper.standard.getLabelSize(text: title.text, font: title.font, maxWidth: maxWidth)
        let membersCountFrameSize = AppWrapper.standard.getLabelSize(text: membersCount.text, font: membersCount.font, maxWidth: maxWidth)

        let arrHeight = [avatarFrameSize.height, titleFrameSize.height + membersCountFrameSize.height + offsets / 2.0]
        let maxHeight = AppWrapper.standard.findMax(arr: arrHeight) + offsets * 2.0 + 1.0

        let avatarOffsetY = (maxHeight - avatarFrameSize.height) / 2.0
        let avatarFrameOrigin = CGPoint(x: offsets, y: avatarOffsetY)
        avatar.frame = CGRect(origin: avatarFrameOrigin, size: avatarFrameSize)

        let titleOffsetX = avatarFrameOrigin.x + avatarFrameSize.width + offsets
        let titleOffsetY = (maxHeight - titleFrameSize.height - offsets - membersCountFrameSize.height) / 2.0
        let titleFrameOrigin = CGPoint(x: titleOffsetX, y: titleOffsetY)
        title.frame = CGRect(origin: titleFrameOrigin, size: titleFrameSize)
        
        let membersCountOffsetX = avatarFrameOrigin.x + avatarFrameSize.width + offsets
        let membersCountOffsetY = titleFrameOrigin.y + titleFrameSize.height + offsets / 2.0
        let membersCountOrigin = CGPoint(x: membersCountOffsetX, y: membersCountOffsetY)
        membersCount.frame = CGRect(origin: membersCountOrigin, size: membersCountFrameSize)
    }
}
