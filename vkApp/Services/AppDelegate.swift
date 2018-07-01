//
//  AppDelegate.swift
//  vkApp
//
//  Created by Андрей Тихонов on 22.03.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import WatchConnectivity
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var watchSession: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        UserNotification.shared.requestAuthorization()
        UserNotification.shared.InitializeNotificationServices()
        
        var groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pixeltron.org.vkApp")
        groupURL?.appendPathComponent("realm.db")

        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration.fileURL = groupURL
        
        if WCSession.isSupported() {
            watchSession = WCSession.default
            watchSession?.delegate = self
            watchSession?.activate()
        }
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        print ("Вызов обновления данных в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 300 {
            print ("Фоновое обновление не требуется, т.к. последний раз данные обновлялись \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше пяти минут)")
                completionHandler(.noData)
            return
        }
        
        var countNewFriend = 0
        var countUnreadMessage = 0
        
        let group = DispatchGroup()
        
        group.enter()
        let request = VKService.getRequestsFriends() { result in
            countNewFriend = result ?? 0
            group.leave()
        }
        
        group.enter()
        let request2 = VKService.unreadMessagesCount() { result in
            countUnreadMessage = result ?? 0
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            UIApplication.shared.applicationIconBadgeNumber = countNewFriend + countUnreadMessage
            self?.timer = nil
            self?.lastUpdate = Date()
            completionHandler(.newData)
        }
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 299, leeway: .seconds(1))
        timer?.setEventHandler {
            print ("Говорим системе, что не смогли загрузить данные")
            request.cancel()
            request2.cancel()
            completionHandler(.failed)
        }
        
        timer?.resume()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        for i in 0..<deviceToken.count {
            VKService.devToken += String(format: "%02.2hhx", arguments: [deviceToken[i]])

        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

//        #if arch(i386) || arch(x86_64)
//            deviceInfo.deviceToken = "05f06c113d59be1e7387dc52a5b4b835ae1bddfbdd5988dcb617cd483182ff09"
//        #else
//            deviceInfo.deviceToken = nil
//        #endif
    }

    // Периодическое обновление
    var newFriendsList: Results<NewFriendProfile>?
    
    let fetchCitiesWeatherGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "Last Update") as? Date
        }
        set {
            UserDefaults.standard.setValue(Date(), forKey: "Last Update")
        }
    }
 // Даем приложению возможность завершить задачи при сворачивании
    var bgTask: UIBackgroundTaskIdentifier!

//    func applicationDidEnterBackground(_ application: UIApplication) {
//        bgTask = application.beginBackgroundTask(withName: "bgUpdate", expirationHandler: {
//            print("Время вышло")
//            application.endBackgroundTask(self.bgTask)
//            self.bgTask = UIBackgroundTaskInvalid
//        })
//        var currentTime: Int = 0
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
//            currentTime += 1
//            print(currentTime)
//        }
//    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler:
        @escaping ([String : Any]) -> Void) {
        guard message["request"] as? String == "friend" else {
            assertionFailure("Тут что-то не так")
            return
        }
        guard let realm = try? Realm() else { return }
        let friendList = realm.objects(FriendProfile.self).sorted(byKeyPath: "lastName")
        var friends = [[String : Any]]()
        var i = 0
        for friend in friendList {
            if i < 15 {
                guard let url = URL(string: friend.photo50URL) else {
                    assertionFailure()
                    return
                }
                let imageData = try? Data(contentsOf: url)
    //            guard let imgData = data, let image = UIImage(data: imgData) else { return }
    //            let imageData = UIImageJPEGRepresentation(image, 0.6)!
                let item = ["image" : imageData as Any, "name" : "   \(friend.firstName)\n   \(friend.lastName)"] as [String : Any]
                friends.append(item)
            }
            i += 1
        }
        replyHandler(["friends" : friends])
    }
}
