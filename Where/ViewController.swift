//
//  ViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/13.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Startボタン押下時の処理
    @IBAction func startButton(_ sender: Any) {
//前回のデータを消去する
//        UserDefaults.standard.removeObject(forKey: "mtName") // [2]山名
//        UserDefaults.standard.removeObject(forKey: "mtLatitude")
//        UserDefaults.standard.removeObject(forKey: "mtLongitude")

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

