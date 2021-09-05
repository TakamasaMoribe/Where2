//
//  CheckBox.swift
//  Where
//
//  Created by 森部高昌 on 2021/09/05.
//

import UIKit

class CheckBox: UIButton {

        // Images
        let checkedImage = UIImage(named: "ico_check_on")! as UIImage
        let uncheckedImage = UIImage(named: "ico_check_off")! as UIImage

        // Bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }

        override func awakeFromNib() {
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
        }

    @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
}
