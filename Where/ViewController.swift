//
//  ViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/13.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 128/255, blue: 168/255, alpha: 1.0) // ボタン背景色設定
        startButton.backgroundColor = rgba                                          // 背景色
        startButton.layer.borderWidth = 0.5                                         // 枠線の幅
        startButton.layer.borderColor = UIColor.black.cgColor                       // 枠線の色
        startButton.layer.cornerRadius = 5.0                                        // 角丸のサイズ
        startButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    // Startボタン押下時の処理
    @IBAction func startButton(_ sender: Any) {
        //前回のデータを消去する
        UserDefaults.standard.removeObject(forKey: "mtName") // [2]山名
        UserDefaults.standard.removeObject(forKey: "mtLatitude")
        UserDefaults.standard.removeObject(forKey: "mtLongitude")
        
        // ①storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!
        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        // ③画面遷移
        self.present(nextView, animated: true, completion: nil)
     }
    
    
    // 設定ボタン押下時の処理
    @IBAction func goSetting(_ sender: Any) {
        //前回のデータを消去する
        UserDefaults.standard.removeObject(forKey: "mtName") // [2]山名
        UserDefaults.standard.removeObject(forKey: "mtLatitude")
        UserDefaults.standard.removeObject(forKey: "mtLongitude")
        
         // ①storyboardのインスタンス取得
         let storyboard: UIStoryboard = self.storyboard!
         // ②遷移先ViewControllerのインスタンス取得
         let nextView = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
         // ③画面遷移
         self.present(nextView, animated: true, completion: nil)
     }

    
    // 前回と同じ　ボタンを押した時　UserDefaultsを消去しない
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

