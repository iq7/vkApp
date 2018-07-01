//
//  InterfaceController.swift
//  WatchKit Extension
//
//  Created by Андрей Тихонов on 22.06.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import WatchKit
import WatchConnectivity
import UIKit

class InterfaceController: WKInterfaceController {

    var watchSession: WCSession?
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func willActivate() {
        super.willActivate()

        if WCSession.isSupported() {
            watchSession = WCSession.default
            watchSession?.delegate = self
            watchSession?.activate()
        }
        
    }

}

extension InterfaceController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        guard activationState == .activated else {
            assertionFailure()
            return
        }
        
        session.sendMessage(["request":"friend"], replyHandler: { (reply) in

            guard let friends = reply["friends"] as? [[String : Any]] else {
                assertionFailure()
                return
            }

            self.tableView.setNumberOfRows(friends.count, withRowType: "tableRow")
            for (index, element) in friends.enumerated() {
                let row = self.tableView.rowController(at: index) as! TableRow
                if let name = element["name"] as? String {
                    row.name.setText(name)
                } else {
                    row.name.setText("Секретный\nагент")
                }

                if
                    let imageData = element["image"] as? Data,
                    let originalImage = UIImage(data: imageData) {
                    let roundedImage = WatchWrapper.standard.imageWithRoundedCornerSize(cornerRadius: 60, usingImage: originalImage)
                    row.avatar.setImage(roundedImage)
                } else {
                    row.avatar.setImage(UIImage(named: "user_male"))
                }
            }
        }, errorHandler: { (error) in
            assertionFailure()
        })
    }
}

struct WatchWrapper {
    
    private init(){}
    
    static let standard = WatchWrapper()
    
    func imageWithRoundedCornerSize(cornerRadius:CGFloat, usingImage original: UIImage) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: original.size.width, height: original.size.height)
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1.0)
        UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).addClip()
        original.draw(in: frame)
        guard let roundedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure("Нешмагла сделать красиво")
            return original
        }
        UIGraphicsEndImageContext()
        return roundedImage
    }
}
