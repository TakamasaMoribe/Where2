//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/12
//

import UIKit

var mountLoc:[[String]] = [] //二重配列にして、空配列にしておく
var areaName:[String] = [] // 地域名を取り出す配列
var mountName:[String] = [] // 山名を取り出す配列


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
        
        mountLoc = dataLoad()//山の配列データをファイルから読み込む[番号、地域名、山名、緯度、経度]
print("mountLoc\(mountLoc)")
        areaName = setAreaName(mountData: mountLoc)//地域名　を取り出して配列にする
print("areaName\(areaName)")
        mountName = setMountName(mountData: mountLoc)//山名　を取り出して配列にする
print("mountName\(mountName)")
        
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

        return dataArray // dataArray = [[番号、地域名、山名、緯度、経度]] 二重配列
    }
    
    
//　地域名だけの配列を取り出す。（ドラムロール１に地域名だけを表示するため）　１つにまとめられる？？？？
        func setAreaName(mountData:[[String]]) -> [String]{
            let mountCount = mountData.count // 山の数
            var areaName:[String] = []
                for i in 0...mountCount-1 {
                    areaName.append(mountData[i][1]) //地域名は、配列内の２番目の要素
                }
            return areaName // 地域名の配列
        }
    
// 山名だけの配列を取り出す。（ドラムロール２に山名だけを表示するため）　　------------------------
    func setMountName(mountData:[[String]]) -> [String]{
        let mountCount = mountData.count // 山の数
        var mountName:[String] = [] // 山名を取り出す配列
            for i in 0...mountCount-1 {
                mountName.append(mountData[i][2]) //山名は、配列内の３番目の要素
            }
        return mountName // 山名の配列
    }
    
//-------------------------------

    // コンポーネントの数（ホイールの数）。ここでは２つになる　地域名と山名
    func numberOfComponents(in myPickerView: UIPickerView) -> Int {
        return 2 //ここではコンポーネントの数は、２
    }
    
    // コンポーネントごとの行数（選択肢の個数）　地域名？個。山名？個
    func pickerView(_ myPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 //       let data = mountName[component]//mountName配列の中から、コンポーネントごとに配列を抜き出し個数を得る
 //       print("mountName:\(mountName)")
 //       print("data:\(data)")
        return areaName.count //mountName.count // 変更の要あり？
    }

    // 選択中のコンポーネントの番号と行から、選択中の項目名を返す　ここでは一次元配列にしたので、[row]列の項目だけ
    func pickerView(_ myPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //指定のコンポーネントから指定中の項目名を取り出す。
        let item = areaName[row]//mountName[row]//項目の番号？
        return item
    }

    // ドラムが回転して、どの項目が選ばれたか。　[row]列の項目？
    func pickerView(_ myPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //現在選択されている行番号 ここでは一次元配列なので、inComponent: 0
        let choice = myPickerView.selectedRow(inComponent: 0)//１つ目のコンポーネント=地域名

        //配列にして保存する。・・決定ボタンを押したら保存するようにすればよい？　この場所でなくても良い？
        UserDefaults.standard.set(mountLoc[choice][0], forKey: "mtName")//山名保存
        UserDefaults.standard.set(mountLoc[choice][1], forKey: "mtLatitude")//緯度保存
        UserDefaults.standard.set(mountLoc[choice][2], forKey: "mtLongitude")//経度保存
    }
    
}


