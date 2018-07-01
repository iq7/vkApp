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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pixeltron.org.vkApp")
        groupURL?.appendPathComponent("realm.db")
        
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
            // таблицы френдов может и не быть
            // и мы споткнемся в этом месте
            let friends = realm.objects(FriendProfile.self)
            
            var x = 10.0
            let y = 10.0
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
                name.frame = CGRect(origin: CGPoint(x: x - 10, y: y + 50), size: CGSize(width: 70, height: 40))
                friendView.addSubview(name)

                img.contentMode = .scaleToFill
                img.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: 50, height: 50))
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
                x += 58.0
            }
        } catch {
            print(error)
        }

        completionHandler(NCUpdateResult.newData)
    }
}
