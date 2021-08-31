//
//  Custombutton.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/31.
//

import UIKit

class Custombutton: UIButton {

    // 角丸の半径(0で四角形)
     @IBInspectable var cornerRadius: CGFloat = 0.0
     // 枠
     @IBInspectable var borderColor: UIColor = UIColor.clear
     @IBInspectable var borderWidth: CGFloat = 0.0
    // 背景色
    @IBInspectable var backColor: UIColor = UIColor.clear

     override func draw(_ rect: CGRect) {
         // 角丸
         self.layer.cornerRadius = cornerRadius
         self.clipsToBounds = (cornerRadius > 0)
        // 枠線
         self.layer.borderColor = borderColor.cgColor
         self.layer.borderWidth = borderWidth
        // 背景色
        self.layer.backgroundColor = backColor.cgColor
        
         super.draw(rect)
         }
}
