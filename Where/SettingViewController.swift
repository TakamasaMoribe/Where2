//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/03.
//

import UIKit

class SettingViewController: ViewController {
    

    @IBAction func returnButton(_ sender: Any) {
        // ①storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!
        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "ViewConrtoller") as! ViewController
        // ③画面遷移
        self.present(nextView, animated: true, completion: nil)
    }
}


