//
//  IMessageCell.swift
//  iMessage
//
//  Created by Андрей Тихонов on 30.06.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

class IMessageCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsfeedText: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    let offsets: CGFloat = 10.0
    let avatarSize: CGFloat = 50.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.frame = CGRect(origin: CGPoint(x: offsets, y: offsets), size: CGSize(width: avatarSize, height: avatarSize))
        AppWrapper.standard.makeBeauty(for: avatar, borderWidth: 1.0, borderColor: .avatarBorderColor)
    }

}
