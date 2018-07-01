//
//  AppWrapper.swift
//  vkApp
//
//  Created by Андрей Тихонов on 23.03.2018.
//  Copyright © 2018 Андрей Тихонов. All rights reserved.
//

import UIKit

struct AppWrapper {
    
    private init(){}

    static let standard = AppWrapper()
    
    func makeBeauty(for el: UIView, borderWidth: CGFloat? = nil, borderRadius: CGFloat? = nil, borderColor: colorEnum? = nil) {
        var bWidth: CGFloat = 2
        var bRadius: CGFloat = el.frame.size.height / 2
        var bColor: CGColor = UIColor.white.cgColor
        if let borderWidth = borderWidth { bWidth = borderWidth }
        if let borderRadius = borderRadius { bRadius = borderRadius }
        if let borderColor = borderColor { bColor = borderColor.value }

        el.clipsToBounds = true
        el.layer.cornerRadius = bRadius
        el.layer.borderWidth = bWidth
        el.layer.borderColor = bColor
    }
    
    func setBgGradient(for uiVc: UIViewController, startColor: CGColor, endColor: CGColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: uiVc.view.frame.size.width, height: uiVc.view.frame.size.height)
        
        uiVc.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func showMessage(title: String, message: String, vc: UIViewController) {
        //Создаем контроллер
        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //Добавляем кнопку на UIAlertController
        alter.addAction(action)
        //показываем UIAlertController
        vc.present(alter, animated: true, completion: nil)
    }
    
    func getLabelSize(text: String?, font: UIFont, maxWidth: CGFloat = 0.0) -> CGSize {
        if let text = text {
            let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            let rect = text.boundingRect(
                with: textBlock,
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedStringKey.font: font],
                context: nil)
            let width = Double(rect.size.width)
            let height = Double(rect.size.height)
            let size = CGSize(width: ceil(width), height: ceil(height))
            return size
        } else {
            let size = CGSize(width: 0, height: 0)
            return size
        }
    }
    
    func findMax(arr: [CGFloat]) -> CGFloat {
        var max: CGFloat = 0.0
        if let arrFirst = arr.first {
            max = arrFirst
            for m in arr {
                if m > max { max = m }
            }
        }
        return max
    }
    
    func convertIntToStrigWithReduction(_ num: Int) -> String? {
        if num == 0 { return nil }
        return num > 1000 ? "\(Double(num / 100)/10)К" : String(num)
    }
    
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
