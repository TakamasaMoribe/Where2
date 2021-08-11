//
//  ViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/07/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Startボタン押下時の処理
    
    @IBAction func startButton(_ sender: Any) {
         // ①storyboardのインスタンス取得
         let storyboard: UIStoryboard = self.storyboard!
         // ②遷移先ViewControllerのインスタンス取得
         let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
         // ③画面遷移
         self.present(nextView, animated: true, completion: nil)
     }
    
    
    // 設定ボタン押下時の処理
    @IBAction func goSetting(_ sender: Any) {
         // ①storyboardのインスタンス取得
         let storyboard: UIStoryboard = self.storyboard!
         // ②遷移先ViewControllerのインスタンス取得
         let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
         // ③画面遷移
         self.present(nextView, animated: true, completion: nil)
     }

}

