//
//  CamersVC.swift
//  vkApp
//
//  Created by Андрей Тихонов on 01.07.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit
import MobileCoreServices

class CamersVC: UIViewController {
    
    @IBOutlet weak var resultPhoto: UIImageView!
    
    let camera = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        
        camera.sourceType = .savedPhotosAlbum
        camera.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        camera.allowsEditing = false
        camera.delegate = self
        camera.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(camera, animated: true, completion: nil)
    }
}

extension CamersVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard
            let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == kUTTypeImage as String,
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        else { return }
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        resultPhoto.image = image

        VKService.getWallUploadServer() { responseUploadPhotoServer in
            guard let responseUploadPhotoServer = responseUploadPhotoServer else {
                assertionFailure()
                return
            }

            if responseUploadPhotoServer.uploadUrl != "" {
                VKService.uploadImageRequest(serverUrl: responseUploadPhotoServer.uploadUrl, image: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true)
    }
}
