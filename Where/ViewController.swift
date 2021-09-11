//
//  ViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/13.
//

import UIKit

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Startボタン押下時の処理
    @IBAction func goSetting(_ sender: Any) {
        //前回のデータを消去する。３ヶ所分
        UserDefaults.standard.removeObject(forKey: "mtName1") // 山名
        UserDefaults.standard.removeObject(forKey: "mtLatitude1") //緯度
        UserDefaults.standard.removeObject(forKey: "mtLongitude1") //経度
        UserDefaults.standard.removeObject(forKey: "mtName2")
        UserDefaults.standard.removeObject(forKey: "mtLatitude2")
        UserDefaults.standard.removeObject(forKey: "mtLongitude2")
        UserDefaults.standard.removeObject(forKey: "mtName3")
        UserDefaults.standard.removeObject(forKey: "mtLatitude3")
        UserDefaults.standard.removeObject(forKey: "mtLongitude3")
         // ①storyboardのインスタンス取得
         let storyboard: UIStoryboard = self.storyboard!
         // ②遷移先ViewControllerのインスタンス取得
         let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
         // ③画面遷移
         self.present(nextView, animated: true, completion: nil)
     }

    
    // 「前回と同じ地点」ボタンを押した時　UserDefaultsを消去しない
    @IBAction func lastTimeButton(_ sender: Any) {
        //前回のデータを消去しないで、地図の描画に入る
        // ①storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!
        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        // ③画面遷移
        self.present(nextView, animated: true, completion: nil)
        
    }
}

