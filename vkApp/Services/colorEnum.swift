//
//  colorEnum.swift
//  vkApp
//
//  Created by Андрей Тихонов on 12.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

enum colorEnum {
    case avatarBorderColor
    case tableCellBackgroundColor
    case tableCellSelectedBackgroundColor
    case gbStartGradient
    case gbStopGradient
}

extension colorEnum {
    var value: CGColor {
        get {
            let d:CGFloat = 255.0
            switch self {
            case .avatarBorderColor:
                return UIColor(red: 240.0/d, green: 13.0/d, blue: 68.0/d, alpha: 1.0).cgColor
            case .tableCellBackgroundColor:
                return UIColor(red: 36.0/d, green: 0.0/d, blue: 12.0/d, alpha: 1.0).cgColor
            case .gbStartGradient:
                return UIColor(red: 235.0/d, green: 101.0/d, blue: 148.0/d, alpha: 1.0).cgColor
            case .gbStopGradient:
                return UIColor(red: 193.0/d, green: 117.0/d, blue: 198.0/d, alpha: 1.0).cgColor
            case .tableCellSelectedBackgroundColor:
                return UIColor.black.cgColor
            }
        }
    }
}
