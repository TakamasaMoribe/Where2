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
    let datas = [["茨城","栃木","群馬","福岡","鹿児島","沖縄"],["筑波山", "男体山", "浅間山"]]
    // 山の緯度経度
    let yamaLoc = [["筑波山",36.1320, 140.0636],["男体山",36.4543, 139.2939],["浅間山",36.2412, 138.3134]]
        
//-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerView.delegate = self
        myPickerView.dataSource = self
    }
//-------------------------------


    // コンポーネントの数（ホイールの数）。ここでは２つになる　県を選択、山を選択
    func numberOfComponents(in myPickerView: UIPickerView) -> Int {
        return datas.count //コンポーネントの数は、2
    }
    
    // コンポーネントごとの行数（選択肢の個数）　県名の数と山名の数
    func pickerView(_ myPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let data = datas[component]//datas配列の中から、コンポーネントごとに配列を抜き出し個数を得る
        return data.count
    }

    // 選択中のコンポーネントの番号と行から、選択中の項目名を返す
    func pickerView(_ myPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //指定のコンポーネントから指定中の項目名を取り出す。
        let item = datas[component][row]//コンポーネントの番号,項目の番号
        return item
    }

    // ドラムが回転して、項目が選ばれた
    func pickerView(_ myPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //現在選択されている行番号
        let row2 = myPickerView.selectedRow(inComponent: 1)//２つ目のコンポーネント 山
        //現在選択されている項目名
        print(yamaLoc[row2][0]) //山名の取り出し
        print(yamaLoc[row2][1]) //緯度
        print(yamaLoc[row2][2]) //経度

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


