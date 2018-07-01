//
//  VKAuthVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 05.04.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import WebKit
import Firebase
import SwiftKeychainWrapper

class VKAuthVC: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.navigationDelegate = self
        webview.load(VKService.authVK(userID: 6615717))
    }
}

extension VKAuthVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }

        decisionHandler(.cancel)
        
        guard
            let token = params["access_token"],
            let userId = params["user_id"]
        else { return }

        let keychain = KeychainWrapper(serviceName: "group.pixeltron.org.vkApp", accessGroup: "group.pixeltron.org.vkApp")
        keychain.set(token, forKey: "vkToken")

        VKService.token = token
        VKService.userId = userId

        let dbLink = Database.database().reference()
        dbLink.child("Users/\(userId)").setValue(["user_id" : userId])

        performSegue(withIdentifier: "authSegue", sender: nil)
    }
}
