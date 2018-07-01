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
    
    var myCurrentPlace: String?

    @IBAction func sendButton(_ sender: UIButton) {
        guard let message = postText.text else {
            assertionFailure()
            return
        }
        if message == "" {
            AppWrapper.standard.showMessage(title: "Сообщение пустое.", message: "Напишите что-нибудь.", vc: self)
        } else {
            var mes = message
            if let myCurrentPlace = myCurrentPlace {
                mes = "\n\(myCurrentPlace)"
            }
            VKService.addPost(message: mes)
        }
    }
    
    @IBAction func okButtonPressed(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let message = postText.text else {
            assertionFailure()
            return
        }
//        if segue.identifier != "selectLocationSegue", message == "" {
//            AppWrapper.standard.showMessage(title: "Сообщение пустое.", message: "Напишите что-нибудь.", vc: self)
//            return
//        }

        var mes = message
        if let myCurrentPlace = myCurrentPlace {
            mes += "\n\(myCurrentPlace)"
        }
        print("\n-------------------------\nVKService.addPost(message: mes)\n----------------\n")
        //VKService.addPost(message: mes)
    }
}
