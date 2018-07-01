//
//  FriendsListCell.swift
//  vkApp
//
//  Created by Андрей Тихонов on 10.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

class FriendsListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.frame = CGRect(origin: CGPoint(x: offsets, y: offsets), size: CGSize(width: avatarSize, height: avatarSize))
        AppWrapper.standard.makeBeauty(for: avatar, borderWidth: 1.0, borderColor: .avatarBorderColor)
    }

    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }

//    static let titleFont = UIFont.systemFont(ofSize: 17.0)
    @IBOutlet weak var title: UILabel! {
        didSet {
            title.translatesAutoresizingMaskIntoConstraints = false
//            title.font = type(of: self).titleFont
        }
    }
    @IBOutlet weak var online: UIImageView! {
        didSet {
            online.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var friend: FriendProfile?
    
    let offsets: CGFloat = 10.0
    let avatarSize: CGFloat = 50.0
    let onlineSize: CGFloat = 20.0

    override func layoutSubviews() {
        super.layoutSubviews()
        initCell(friend)
    }

    func initCell(_ cell: FriendProfile?) {
        guard let cell = cell else { return }

        title.text = cell.name
        online.image = nil
        if cell.online == 1 {
            online.image = cell.lastSeen != 7 ? UIImage(named: "monitor") : UIImage(named: "cell_phone")
        }
        avatar.image = nil

        initFrames()
    }

    private func initFrames() {
        let boundsWidth = UIScreen.main.bounds.width

        let avatarFrameSize = CGSize(width: avatarSize, height: avatarSize)
        let onlineFrameSize = CGSize(width: onlineSize, height: onlineSize)
        let maxWidth = boundsWidth - avatarFrameSize.width - onlineFrameSize.width - offsets * 4.0
        let nameFrameSize = AppWrapper.standard.getLabelSize(text: title.text, font: title.font, maxWidth: maxWidth)

        let arrHeight = [avatarFrameSize.height, onlineFrameSize.height, nameFrameSize.height]
        let maxHeight = AppWrapper.standard.findMax(arr: arrHeight) + offsets * 2.0 + 1.0

        let avatarFrameOriginY = (maxHeight - avatarFrameSize.height) / 2.0
        let avatarFrameOrigin = CGPoint(x: offsets, y: avatarFrameOriginY)
        avatar.frame = CGRect(origin: avatarFrameOrigin, size: avatarFrameSize)

        let nameFrameOriginY = (maxHeight - nameFrameSize.height) / 2.0
        let nameOffsetX = avatarFrameOrigin.x + avatarFrameSize.width + offsets
        let nameFrameOrigin = CGPoint(x: nameOffsetX, y: nameFrameOriginY)
        title.frame = CGRect(origin: nameFrameOrigin, size: nameFrameSize)

        let onlineFrameOriginY = (maxHeight - onlineFrameSize.height) / 2.0
        let onlineOffsetX = boundsWidth - onlineFrameSize.width - offsets
        let onlineFrameOrigin = CGPoint(x: onlineOffsetX, y: onlineFrameOriginY)
        online.frame = CGRect(origin: onlineFrameOrigin, size: onlineFrameSize)
    }
}
