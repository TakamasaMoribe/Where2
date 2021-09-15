//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/09/04
//

import UIKit

var originalMountDatas:[[String]] = [] //山の基本データ。二重配列にして、空にしておく
let areaName = ["北海道","東北","関東甲越","中部","近畿中国","四国九州","海外"] // 地域名
var selectedRegion:String = "" // ドラムロール１で選んだ地域名
var selectedMounts:[[String]] = [] //地域に応じた山の基本データ originalMountDatasから取り出す func extract
var selectedMountsName:[String] = [] // 地域に応じた山名を入れる配列
var choice:Int = 0 // ドラムロール２で選択した項目の番号（山の名前）



class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstRedLabel: UILabel! // １番赤色
    @IBOutlet weak var secondBlueLabel: UILabel! // ２番青色
    @IBOutlet weak var thirdGreenLabel: UILabel! // ３番緑色 紫色にした
    
    @IBOutlet weak var redButton: CheckBox!
    @IBOutlet weak var blueButton: CheckBox!
    @IBOutlet weak var greenButton: CheckBox!
    
    
    
    @IBAction func checkView(_ sender: CheckBox) {
         print(sender.isChecked)
     }
    
    @IBOutlet weak var areaPickerView: UIPickerView! // 地域名用のドラムロール
    @IBOutlet weak var mountPickerView: UIPickerView! // 山名用のドラムロール
    
    @IBOutlet weak var selectMtButton: Custombutton! // 目的地を選択後に押すボタン
    @IBAction func selectMtButton(_ sender: Any) { //目的地の選択終了ボタン
        targetMountain() // 山名選択に応じて、赤、青、緑の線を引く山の名前を決める
        //selectAreaButton.isHidden = false // 「地域選択」ボタンを表示する
        //selectAreaButton.isEnabled = true // 有効にする
    }
    
    @IBOutlet weak var selectAreaButton: Custombutton!
    // 地域名を選択後に押すボタン
    @IBAction func selectAreaButton(_ sender: Any) { //地域名の選択終了ボタン
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
        
        // 「目的地選択」ボタンを表示して有効化する
        selectMtButton.isHidden = false // 「目的地選択」ボタンを表示する
        selectMtButton.isEnabled = true // 有効にする
//        selectAreaButton.isHidden = true // 「地域選択」ボタンを隠す
//        selectAreaButton.isEnabled = false // 無効にする
        
    }
    
    @IBAction func returnButton(_ sender: Any) { //「Start」ボタン押下時。設定を終了して、地図へ画面遷移する
        //山名を選択せずに、Startボタンを押した場合の処理。
            if choice == 0 {
                // ドラムロール１の地域名は選択すみである
                selectedMounts = extract(selectedRegion,originalMountDatas)// 地域名に応じた山のデータを得る
                // ドラムロール２の、０行目（最初の行の山名）を選択したことにする
                let mtName = selectedMounts[0][2] //[2]山名
                let mtLatitude = selectedMounts[0][3] //[3]緯度
                let mtLongitude = selectedMounts[0][4] //[4]経度

                UserDefaults.standard.set(mtName, forKey: "mtName") // 山名保存
                UserDefaults.standard.set(mtLatitude, forKey: "mtLatitude") // 緯度保存
                UserDefaults.standard.set(mtLongitude, forKey: "mtLongitude") // 経度保存
            }
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
    
//-------------------------------
    // 山名だけ取り出した配列をつくる。（ドラムロールに山名だけを表示するため）
    func setMountsName(mountData:[[String]]) -> [String]{
        let mountCount = mountData.count // 山の数
        var mountsName:[String] = [] // 山名を取り出す配列　最初の宣言はいらない
            for i in 0...mountCount-1 {
                mountsName.append(mountData[i][2]) //山名は、配列内の３番目[番号、地域名、山名、緯度、経度]
            }
        return mountsName // 山名の配列を返す
    }
    
//-------------------------------
    // 二重配列から、特定の要素を含む配列を取り出して、新しい二重配列をつくる
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
    
//-------------------------------
    // 山名を選択したら、赤・青・緑の線を引く山の名前を設定し、緯度・経度のデータを保存する
    func targetMountain()   {
        let row2 = mountPickerView.selectedRow(inComponent: 0)//コンポーネント１内の行番号
        choice = row2 // ドラムロール２で選択した項目の番号
        if redButton.isChecked == false {
            firstRedLabel.text = selectedMounts[choice][2] // 赤線で引く山名を表示する
            redButton.isChecked = true
            UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName1") //[2]山名保存
            UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude1") //[3]緯度保存
            UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude1") //[4]経度保存
            
        }else {
            if blueButton.isChecked == false {
                secondBlueLabel.text = selectedMounts[choice][2] // 青線で引く山名を表示する
                blueButton.isChecked = true
                UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName2") //[2]山名保存
                UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude2") //[3]緯度保存
                UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude2") //[4]経度保存
            }else {
                if greenButton.isChecked == false {
                    thirdGreenLabel.text = selectedMounts[choice][2] // 緑線で引く山名を表示する
                    greenButton.isChecked = true
                    UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName3") //[2]山名保存
                    UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude3") //[3]緯度保存
                    UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude3") //[4]経度保存
                }else {
                //
                }
            }
        }
    }

// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
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
            selectedMounts = extract(selectedRegion,originalMountDatas)// 山のデータ配列を取り出す
            
        } else {
            if (picker.tag == 2){ // 地域名に応じた山名を表示する
                // targetMountain() // メソッドで、場合分けして処理する
            }
        }
        // 前回使ったときのデータに上書きするために必要？？？？？？？
        UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName") //[2]山名保存
        UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude") //[3]緯度保存
        UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude") //[4]経度保存
    }
    

    // ドラムロールに表示するテキストの属性を設定する
    func pickerView(_ picker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 表示するラベルを生成する
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont(name: "System",size:18)
        label.textColor = .black
        
        if (picker.tag == 1){
            label.text = areaName[row] //dataArray[row]
        } else {
            label.text = selectedMountsName[row] //dataArray[row]
        }
        return label
    }
    
//---------------------------------------------------------------------------------

}

