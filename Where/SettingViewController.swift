//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/12
//

import UIKit

var mountLoc:[[String]] = [] //二重配列にして、空配列にしておく
var datas:[String] = [] // 山名を取り出す配列


class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    @IBAction func returnButton(_ sender: Any) { //設定を終了して、地図へ画面遷移する
        // 追加した山名と緯度経度の保存
        let mtName = UserDefaults.standard.string(forKey: "mtName")//山名をmtNameへ読み込み
        let mtLatitude = UserDefaults.standard.double(forKey: "mtLatitude")//緯度をmtLatitude
        let mtLongitude = UserDefaults.standard.double(forKey: "mtLongitude")//経度をmtLongitude
        UserDefaults.standard.set(mtName, forKey: "mtName")//山名保存
        UserDefaults.standard.set(mtLatitude, forKey: "mtLatitude")//緯度保存
        UserDefaults.standard.set(mtLongitude, forKey: "mtLongitude")//経度保存

        // 地図表示へ画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        self.present(nextView, animated: true, completion: nil)
    }

        
//-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        mountLoc = dataLoad()//山の配列データ[山名、緯度、経度]
print("mountLoc\(mountLoc)")
        datas = setMountName(mountData: mountLoc)//山名のみの配列
print("datas\(datas)")
        
    }
//-------------------------------
    //csvファイルから、山のデータを読み込む
    func dataLoad() -> [[String]] {

        //データを格納するための配列を準備する
        var dataArray :[[String]] = [] //二重配列にして、空配列にしておく
        
        //データの読み込み準備 ファイルが見つからないときは実行しない
        guard let thePath = Bundle.main.path(forResource: "mtDataAll", ofType: "csv") else {
            return [["null"]]
        }
        
         do {
            let csvStringData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
            csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                let data = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                dataArray.append(data) //格納用の配列に、１行ずつ追加していく
                }) //invokingからのクロージャここまで

            }catch let error as NSError {
             print("ファイル読み込みに失敗。\n \(error)")
         } //Do節ここまで

        return dataArray // dataArray = [[山名、緯度、経度]] 二重配列
    }
//-------------------------------

// 山名だけの配列を取り出す。（ドラムロールに山名だけを表示するため）　-------------------------------
    func setMountName(mountData:[[String]]) -> [String] {
        let mountCount = mountData.count // 山の数
        var mountName:[String] = [] // 山名を取り出す配列
            for i in 0...mountCount-1 {
                mountName.append(mountData[i].first!) //山名は、配列内の最初の要素
            }
        return mountName // 山名だけの配列
    }
    
//-------------------------------

    // コンポーネントの数（ホイールの数）。ここでは１つになる　山名だけ
    func numberOfComponents(in myPickerView: UIPickerView) -> Int {
        return 1 //mountLoc[0].count//　と書けば汎用的？ //ここではコンポーネントの数は、1
    }
    
    // コンポーネントごとの行数（選択肢の個数）　ここでは山名の数だけ
    func pickerView(_ myPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 //       let data = datas[component]//datas配列の中から、コンポーネントごとに配列を抜き出し個数を得る
 //       print("datas:\(datas)")
 //       print("data:\(data)")
        return datas.count // 変更の要あり？
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

        //配列にして保存する・・・決定ボタンを押したら保存する・・・・この場所でなくても良い？
        UserDefaults.standard.set(mountLoc[choice][0], forKey: "mtName")//山名保存
        UserDefaults.standard.set(mountLoc[choice][1], forKey: "mtLatitude")//緯度保存
        UserDefaults.standard.set(mountLoc[choice][2], forKey: "mtLongitude")//経度保存
    }
    

}


