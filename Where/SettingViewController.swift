//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/22
//

import UIKit

var originalMountDatas:[[String]] = [] //山の基本データ。二重配列にして、空配列にしておく
let areaName = ["北海道","東北","関東甲信越","中部","近畿中国","四国九州"] // 地域名
var selectedRegion:String = "" // ドラムロールで選んだ地域名
var selectedMounts:[[String]] = [] //地域に応じた山の基本データ originalMountDatasから取り出す func extract
var selectedMountsName:[String] = [] // 地域に応じた山名を入れる配列

var choice:Int = 0 // ドラムロールで選択した項目の番号



class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var areaPickerView: UIPickerView! // 地域名
    @IBOutlet weak var mountPickerView: UIPickerView! // 山名
    
    @IBAction func selectButton(_ sender: Any) { //地域名の選択終了ボタン
        //地域名を選択せずに、選択ボタンを押した場合の処理。
            if selectedRegion == "" {
                // ０行目（最初の行の地域名）を選択したことする
                let region = self.pickerView(areaPickerView, titleForRow:0, forComponent: 0)
                selectedRegion = region!
            }
        // 選択した地域名に応じた山のデータ配列を抜き出す　word:検索する地域名、Array:検索対象の配列
        selectedMounts = extract(selectedRegion,originalMountDatas) // func extract()
        // 選択した地域名に応じた山名の配列を得る
        selectedMountsName = setMountsName(mountData: selectedMounts) // func setMountsName()
        //mountPickerView を初期化して、選択した山名　selectedMountsName を表示する
        mountPickerView.reloadAllComponents()
        
    }
    
    @IBAction func returnButton(_ sender: Any) { //設定を終了して、地図へ画面遷移する
        // 追加した山名と緯度経度の保存
        let mtName = UserDefaults.standard.string(forKey: "mtName") // 山名をmtNameへ読み込み
        let mtLatitude = UserDefaults.standard.double(forKey: "mtLatitude") // 緯度をmtLatitude
        let mtLongitude = UserDefaults.standard.double(forKey: "mtLongitude") // 経度をmtLongitude
        UserDefaults.standard.set(mtName, forKey: "mtName") // 山名保存
        UserDefaults.standard.set(mtLatitude, forKey: "mtLatitude") // 緯度保存
        UserDefaults.standard.set(mtLongitude, forKey: "mtLongitude") // 経度保存
        
        // 地図表示へ画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
        self.present(nextView, animated: true, completion: nil)
    }

        
//-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        areaPickerView.delegate = self
        areaPickerView.dataSource = self
        mountPickerView.delegate = self
        mountPickerView.dataSource = self
        areaPickerView.tag = 1
        mountPickerView.tag = 2
        
        //山の配列データをcsvファイルから読み込む。[番号、地域名、山名、緯度、経度]
        originalMountDatas = dataLoad()
        
    }
//-------------------------------
    // csvファイルから、山のデータを読み込む
    func dataLoad() -> [[String]] {
        // データを格納するための配列を準備する
        var dataArray :[[String]] = [] // 二重配列にして、空配列にしておく
        // データの読み込み準備 ファイルが見つからないときは実行しない
        guard let thePath = Bundle.main.path(forResource: "mtDataAll", ofType: "csv") else {
            return [["null"]]
        }
         do {
            let csvStringData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
            csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                let data = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                dataArray.append(data) // 格納用の配列に、１行ずつ追加していく
                }) // invokingからのクロージャここまで
            }catch let error as NSError {
             print("ファイル読み込みに失敗。\n \(error)")
         } // Do節ここまで
        return dataArray // dataArray = [[番号、地域名、山名、緯度、経度]] 二重配列
    }
    
    
// 山名だけ取り出した配列をつくる。（ドラムロールに山名だけを表示するため）
    func setMountsName(mountData:[[String]]) -> [String]{
        let mountCount = mountData.count // 山の数
        var mountsName:[String] = [] // 山名を取り出す配列　最初の宣言はいらない
            for i in 0...mountCount-1 {
                mountsName.append(mountData[i][2]) //山名は、配列内の３番目[番号、地域名、山名、緯度、経度]
            }
        return mountsName // 山名の配列を返す
    }
    
//-------------------------------------------------------------------------------
    // コンポーネントの数（ホイールの数）
    func numberOfComponents(in picker: UIPickerView) -> Int {
        if (picker.tag == 1){  //tagで分岐
            return 1 //地域名用は１個
        }else{
            if (picker.tag == 2){
                return 1 // 山名用も１個
            }else{
                return 1 //必要ないが
        }
    }
        
//func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // あやしい
    }
    // コンポーネントの行数（配列の要素数＝選択肢の個数）を得る。
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (picker.tag == 1){ //地域名を表示するドラムロール
            return areaName.count // 地域名の個数＝６　"北海道","東北","関東甲信越","中部","近畿中国","四国九州"
        } else {
            if (picker.tag == 2){ //山名を表示するドラムロール
                return selectedMountsName.count // 選択した地域に属する山名の個数
            } else {
                return 0 //必要ないが 0にしてみる
            }
        }
    }

    // 選択中のコンポーネントの番号と行から、指定した配列[areaName]と[mountsName]から項目名を返す
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 指定のコンポーネントから 選択中の項目名を取り出す。
        if (picker.tag == 1){ // tagで分岐
            return areaName[row] // row行目の地域名
        } else {
            if (picker.tag == 2){// row行目の山名 [areaName]の内容によってここを更新する
                return selectedMountsName[row]
            } else {
                return "該当なし"  //必要ないが
            }
        }
    }

    // ドラムが回転して、どの項目が選ばれたか。情報を得る。
    //row1,row2でコンポーネント内の行番号。item1,item2でその内容。
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //現在選択されている行番号とその内容
        
        if (picker.tag == 1){ //tagで分岐
            // 選択した行番号を得る
            let row1 = areaPickerView.selectedRow(inComponent: 0)
            // 選択した行番号から、タイトル名（地域名）を得る
            let item1 = self.pickerView(areaPickerView, titleForRow: row1, forComponent: 0)
            
            // 選んだ地域に応じて、山のデータ配列をつくる
            selectedRegion = item1!
            selectedMounts = extract(selectedRegion,originalMountDatas)// 地域名に応じた山のデータを得る
            // あとで、選択ボタンを押したならば、mountsNameも地域に応じたものに変更し、山名の配列をつくる。
        } else {
            if (picker.tag == 2){ //ここで、地域名に応じた山名を表示するようにする
                let row2 = mountPickerView.selectedRow(inComponent: 0)//コンポーネント１内の行番号
                choice = row2 // 選択した項目の番号から選択した山名を得る
            }
        }
        // 前回使ったときのデータに上書きするために必要
        UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName") //[2]山名
        UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude") //[3]緯度保存
        UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude") //[4]経度保存
    }
 
    // 二重配列から、特定の要素を含む配列を取り出して、新しい二重配列をつくる ----------------------
    // 地域名に応じた山のデータ配列を抜き出す　word:検索する地域名、Array:検索対象の配列
    func extract(_ word:String ,_ Array:[[String]]) -> [[String]] {
        var filtered:[[String]] = []//　ドラムロールで選択した"地域名"を含む。抽出した配列
        var j = 0 // ループカウンタ
        for array in originalMountDatas { //山のデータ配列[番号、地域名、山名、緯度、経度]
            // array[1]:２番目の要素（地域名）だけ調べる
            if array[1] == selectedRegion { //取り出した要素が、検索値に等しい時
                filtered.append(array)
            }
            j = j + 1
        }
        return filtered
    }
    //---------------------------------------------------------------------------------
    
}


