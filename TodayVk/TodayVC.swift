//
//  TodayVC.swift
//  TodayVk
//
//  Created by Андрей Тихонов on 05.06.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift
import Alamofire

class TodayVC: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var friendView: UIView!

    var maxWidth: CGFloat = 0.0
    let offset: CGFloat = 10.0
    var avatarWidth: CGFloat = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()

        var groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pixeltron.org.vkApp")
        guard let _ = groupURL?.appendPathComponent("realm.db") else {
            assertionFailure("Для начала нужно посетить вкладку друзей в приложении")
            return
        }
        
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration.fileURL = groupURL
        AppWrapper.standard.setBgGradient(for: self, startColor: colorEnum.gbStartGradient.value, endColor: colorEnum.gbStopGradient.value)
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        for subview in friendView.subviews {
            subview.removeFromSuperview()
        }
        
        do {
            let realm = try Realm()
            let friends = realm.objects(FriendProfile.self)
            
            maxWidth = friendView.bounds.width
            let separator = (maxWidth - offset * 2 - avatarWidth * 5) / 4

            var x: CGFloat = 10.0
            let y: CGFloat = 10.0
            for i in 0..<5 {
                let friend = friends[i]
                let imageURL = friend.photo50URL
                let img = UIImageView()
                let name = UILabel()
                name.text = friend.name
                name.font = UIFont.systemFont(ofSize: 12)
                name.numberOfLines = 0
                name.textAlignment = .center
                name.textColor = UIColor.white
                name.frame = CGRect(origin: CGPoint(x: x - separator/2 + 2, y: y + avatarWidth), size: CGSize(width: avatarWidth + separator - 2, height: 40))
                friendView.addSubview(name)

                img.contentMode = .scaleToFill
                img.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: avatarWidth, height: avatarWidth))
                AppWrapper.standard.makeBeauty(for: img, borderWidth: 1.0)
                Alamofire.request(imageURL).responseData(queue: DispatchQueue.global()) { response in
                    guard
                        let data = response.data,
                        let image = UIImage(data: data) else { return }
                    
                    DispatchQueue.main.async {
                        img.image = image
                    }
                }
                friendView.addSubview(img)
                x += avatarWidth + separator
            }
        } catch {
            print(error)
        }

        completionHandler(NCUpdateResult.newData)
    }
}
