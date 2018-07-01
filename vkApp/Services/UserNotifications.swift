//
//  UserNotifications.swift
//  vkApp
//
//  Created by Андрей Тихонов on 24.06.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotification: NSObject {
    
    static let shared = UserNotification()
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if success {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            } else {
                print("Пользователь запретил доступ к уведомлениям")
            }
        }
    }
    
    func InitializeNotificationServices() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if success {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                        })
                    UserNotification.shared.CreateNotification()
                } else {
                    print("Пользователь запретил доступ к уведомлениям")
                }
            }
        } else {
            let setting = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func CreateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Мое уведомление"
        content.subtitle = "Ты умничка"
        content.body = "У тебя все получилось"
        content.sound = UNNotificationSound.init(named: "NoizeMC.caf")

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let request = UNNotificationRequest(identifier: "Notif", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension UserNotification: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
