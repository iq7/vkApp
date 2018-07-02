//
//  PostVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 25.05.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import CoreLocation

class PostVC: UIViewController {
    
    @IBOutlet weak var postText: UITextField!

    @IBAction func sendButton(_ sender: UIButton) {
    }
    
    @IBAction func okButtonPressed(unwindSegue: UIStoryboardSegue) {
    }
    
    var attachment: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let message = postText.text else {
            assertionFailure()
            return
        }

        if segue.identifier == "sendMessagePressed" {
            if message == "" {
                AppWrapper.standard.showMessage(title: "Сообщение пустое.", message: "Напишите что-нибудь.", vc: self)
                return
            }
            print("-------------------------------")
            print("VKService.addPost(message: mes)")
            print("-------------------------------")
            VKService.addPost(message: message, attachment: attachment)
        }
    }
}
