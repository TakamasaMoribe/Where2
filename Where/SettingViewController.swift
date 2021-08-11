//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/10
//

import UIKit

class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    @IBAction func returnButton(_ sender: Any) {
        // 追加した山名と緯度経度の保存
        let mtName = UserDefaults.standard.string(forKey: "mtName")//山名mtNameへ読み込み
        let mtLatitude = UserDefaults.standard.double(forKey: "mtLatitude")//緯度mtLatitude
        let mtLongitude = UserDefaults.standard.double(forKey: "mtLongitude")//経度mtLongitude
        UserDefaults.standard.set(mtName, forKey: "mtName")//山名保存
        UserDefaults.standard.set(mtLatitude, forKey: "mtLatitude")//緯度保存
        UserDefaults.standard.set(mtLongitude, forKey: "mtLongitude")//経度保存

        // 地図表示へ画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        self.present(nextView, animated: true, completion: nil)
            
    }
    // ドラムロールボタンの選択肢を配列にして格納する
    let datas = ["筑波山", "男体山", "浅間山"] //ドラム１個で、山名だけの表示
    // 山の緯度経度の値　ｃｓｖファイルを作って、読み込む形にする
    let mountLoc = [["筑波山",36.2253, 140.1067],["男体山",36.7650, 139.4908],["浅間山",36.406333, 138.52300]]
    
        
//-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerView.delegate = self
        myPickerView.dataSource = self

    }
//-------------------------------
    // コンポーネントの数（ホイールの数）。ここでは１つになる　山名だけ
    func numberOfComponents(in myPickerView: UIPickerView) -> Int {
        return 1 //datas.count //ここではコンポーネントの数は、1
    }
    
    // コンポーネントごとの行数（選択肢の個数）　ここでは山名の数だけ
    func pickerView(_ myPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let data = datas[component]//datas配列の中から、コンポーネントごとに配列を抜き出し個数を得る
        return data.count
    }

    // 選択中のコンポーネントの番号と行から、選択中の項目名を返す　ここでは一次元配列にしたので、[row]列の項目だけ
    func pickerView(_ myPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //指定のコンポーネントから指定中の項目名を取り出す。
        let item = datas[row]//項目の番号
        return item
    }

    // ドラムが回転して、項目が選ばれた　ここでは一次元配列にしたので、[row]列の項目だけ
    func pickerView(_ myPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //現在選択されている行番号 ここでは一次元配列なので、inComponent: 0　１つ目のコンポーネント=山名
        let choice = myPickerView.selectedRow(inComponent: 0)//

        //配列にして保存する・・・決定ボタンを押したら保存する
        UserDefaults.standard.set(mountLoc[choice], forKey: "mountLocTemp")//全部保存　不使用
        UserDefaults.standard.set(mountLoc[choice][0], forKey: "mtName")//山名保存
        UserDefaults.standard.set(mountLoc[choice][1], forKey: "mtLatitude")//緯度保存
        UserDefaults.standard.set(mountLoc[choice][2], forKey: "mtLongitude")//経度保存
    }
    


}


