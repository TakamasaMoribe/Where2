//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/03.
//

import UIKit

class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    // ドラムロールボタンの選択肢を配列にして格納
    let datas = ["筑波山", "男体山", "浅間山"] //最初は、山名だけの表示にしてみる
    //let datas = [["茨城","栃木","群馬","福岡","鹿児島","沖縄"],["筑波山", "男体山", "浅間山"]]
    // 山の緯度経度
    let mountLoc = [["筑波山",36.1320, 140.0636],["男体山",36.4543, 139.2939],["浅間山",36.2412, 138.3134]]
        
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

    }
    
    
    
    
//------------------------------------------
    @IBAction func returnButton(_ sender: Any) {
        // ①storyboardのインスタンス取得
        let storyboard: UIStoryboard = self.storyboard!
        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "ViewConrtoller") as! ViewController
        // ③画面遷移
        self.present(nextView, animated: true, completion: nil)
    }
//------------------------------------------

}


