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
    //------追加した山の値の保存
        let tempList = UserDefaults.standard.array(forKey: "mountLocTemp")//tempListへ読み込み
        UserDefaults.standard.set(tempList, forKey: "mountLocTemp") //"mountLocTemp"として保存
         //print("save \(tempList!)")//確認用出力
         // UserDefaults.standard.set(myList, forKey: "myList")
    // 地図表示へ画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        self.present(nextView, animated: true, completion: nil)
        
    //------
            
    }
    
    // ドラムロールボタンの選択肢を配列にして格納
    let datas = ["筑波山", "男体山", "浅間山"] //最初は、山名だけの表示にしてみる
    // 山の緯度経度
    let mountLoc = [["筑波山",36.1320, 140.0636],["男体山",36.4543, 139.2939],["浅間山",36.406333, 138.52300]]

        
//-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        //PickerViewが表示された時、まだ選択されていないので、確認表示用にdefaultとして浅間山を使う
        print("default\(mountLoc[0][0])") //山名の取り出し　浅間山
        print("default\(mountLoc[0][1])") //緯度
        print("default\(mountLoc[0][2])") //経度
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
        //現在選択されている行番号
        let choice = myPickerView.selectedRow(inComponent: 0)//ここでは一次元配列＝inComponent: 0　１つ目のコンポーネント 山
        //現在選択されている項目名
        print(mountLoc[choice][0]) //山名の取り出し
        print(mountLoc[choice][1]) //緯度
        print(mountLoc[choice][2]) //経度
        //配列にして保存する・・・決定ボタンを押したら保存する
        UserDefaults.standard.set(mountLoc[choice], forKey: "mountLocTemp")//保存
print("choice\(mountLoc[choice])")
        UserDefaults.standard.set(mountLoc[choice][0], forKey: "mountLocTempMtName")//山名保存
        UserDefaults.standard.set(mountLoc[choice][1], forKey: "mountLocTempLatitude")//緯度保存
        UserDefaults.standard.set(mountLoc[choice][2], forKey: "mountLocTempLongitude")//経度保存
        let tempName = UserDefaults.standard.string(forKey: "mountLocTempMtName")//山名読み出し
print("tempList\(tempName!)")
        let tempLatitude = UserDefaults.standard.double(forKey: "mountLocTempLatitude")//緯度読み出し
print("tempLatitude\(tempLatitude)")
        let tempLongitude = UserDefaults.standard.double(forKey: "mountLocTempLongitude")//経度読み出し
print("tempLongitude\(tempLongitude)")
    }
    


}


