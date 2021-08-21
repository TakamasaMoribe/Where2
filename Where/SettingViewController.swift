//
//  SettingViewController.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/18
//

import UIKit

var mountLoc:[[String]] = [] //山の基本データ。二重配列にして、空配列にしておく
let areaName = ["北海道","東北","関東甲信越","中部","近畿中国","四国九州"] // 地域名
var selectedRegion:String = "" // ドラムロールで選んだ地域名
var selectedMounts:[[String]] = [] //地域に応じた山の基本データ [[mountLoc]]から取り出す func extract
var mountsName:[String] = [] // 山名を入れる配列
var selectedMountsName:[String] = [] // 地域に応じた山名を入れる配列
var choice:Int = 0 // ドラムロールで選択した項目の番号
var flag:Bool = false //地域名の選択ボタンを押したかどうか。山名の絞り込み開始に利用する



//地域名を選び、その中の山を選ぶ。地域名と山名で構成される二重配列を作っておく・・・・不要になる？？？
let compos = [areaName,mountsName] //コンポーネントに表示する配列


class SettingViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var areaPickerView: UIPickerView! // 地域名
    @IBOutlet weak var mountPickerView: UIPickerView! // 山名
    
    @IBAction func selectButton(_ sender: Any) { //地域名の選択終了ボタン
        flag = true // 選択ボタンを押したフラグ
        // mountPickerView に表示する山名を、areaPickerView　で選んだ地域のものにする
        // mountLoc:[[String]] から抜き出して、新しく配列を作る
        // reload()する
        // 地域名に応じた山のデータ配列を抜き出す　word:検索する地域名、Array:検索対象の配列
        selectedMounts = extract(selectedRegion,mountLoc)// 地域に応じた山のデータ・・・ここの戻り値 filterd は正しい
        mountPickerView.reloadAllComponents() //山名を表示する方のPickerView を初期化する
        
    }
    
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
        areaPickerView.delegate = self
        areaPickerView.dataSource = self
        mountPickerView.delegate = self
        mountPickerView.dataSource = self
        areaPickerView.tag = 1
        mountPickerView.tag = 2
        
        mountLoc = dataLoad()//山の配列データをファイルから読み込む[番号、地域名、山名、緯度、経度]
        mountsName = setmountsName(mountData: mountLoc)//山名だけ　を取り出して配列にする
        selectedMounts = dataLoad()//山の配列データをファイルから読み込む[番号、地域名、山名、緯度、経度]
        selectedMountsName = setmountsName(mountData: selectedMounts)//山名だけ　を取り出して配列にする selectedMountsにしてみた
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
    
    
// 山名だけ取り出した配列をつくる。（ドラムロールに山名だけを表示するため）
    func setmountsName(mountData:[[String]]) -> [String]{
        let mountCount = mountData.count // 山の数
        var mountsName:[String] = [] // 山名を取り出す配列
            for i in 0...mountCount-1 {
                mountsName.append(mountData[i][2]) //山名は、配列内の３番目の要素
            }
        return mountsName // 山名の配列
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
        
 //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    }
    // コンポーネントの行数（配列の要素数＝選択肢の個数）を得る。ここを７回繰り返す。
    // 地域選択後ドラム２で、flag を使って、mountsName.count を selectedMountsName.count に変えてみる
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (picker.tag == 1){ //地域名を表示するドラムロール
            print("areaName.count①:\(areaName.count)") // ここを７回繰り返す。＊＊＊＊＊＊＊＊＊＊＊＊
            return areaName.count // 地域名の個数
        } else {
            if (picker.tag == 2){ //山名を表示するドラムロール
                if (flag == true) { //？？？？？？？？？？？　地域名の選択ボタンを押した時 ここにこない？？？？？？？？
                    //selectedMountsName = setmountsName(mountData: selectedMounts) // 地域名に応じた山名の配列を得る
                    //print("selectedMountsName:\(selectedMountsName)")// ドラムロール２を回すと、表示される
                    //print("selectedMountsName[row]:\(selectedMountsName[row])")
                    print("ここ　selectedMountsName.count①:\(selectedMountsName.count)") // ここに来ない＊＊＊＊＊＊＊
                    return selectedMountsName.count
                }
                print("mountsName.count①:\(mountsName.count)") // 次に、ここを７回繰り返す。＊＊＊＊＊＊＊＊＊＊＊＊
                return mountsName.count // 山名の個数
            } else {
                return 0 //必要ないが 0にしてみる
            }
        }
    }

    // 選択中のコンポーネントの番号と行から、指定した配列[areaName]と[mountsName]から項目名を返す row行目・・out of range
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //指定のコンポーネントから指定中の項目名を取り出す。
        if (picker.tag == 1){ //tagで分岐
            return areaName[row] // row行目の地域名
        } else {
            if (picker.tag == 2){// row行目の山名 [areaName]の内容によってここを更新する？
                
                if (flag == true) { //地域名の選択ボタンを押した時
                    selectedMountsName = setmountsName(mountData: selectedMounts) // 地域名に応じた山名の配列を得る
                    //row = selectedMountsName.count - 1
                    print("selectedMountsName②:\(selectedMountsName)")// ドラムロール２を回すと、表示される
                    print("selectedMountsName.count②:\(selectedMountsName.count)")//
                    print("row:\(row)")//rowの値が範囲を超える
                    print("selectedMountsName[row]②:\(selectedMountsName[row])")
                    return selectedMountsName[row] 
                }
                print("mountsName[row]②\(mountsName[row])") // countを７回繰り返した後、次にここに来る
                return mountsName[row]
                //return mountsName[row] // row行目の山名 [areaName]の内容によってここを更新する？
            } else {
                return "該当なし"  //必要ないが
            }
        }
    }

    // ドラムが回転して、どの項目が選ばれたか。情報を得る。
    //row1,row2でコンポーネント内の行番号。item1,item2でその内容。 ここでもtagで分岐する
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //現在選択されている行番号とその内容
        if (picker.tag == 1){ //tagで分岐
            let row1 = areaPickerView.selectedRow(inComponent: 0)//コンポーネント１内の行番号
            let item1 = self.pickerView(areaPickerView, titleForRow: row1, forComponent: 0)//地域名
            print("ドラム１のrow1③:\(row1)")
            print("ドラム１のitem1!③:\(item1!)")
            
         //選んだ地域に応じて、山のデータ配列をつくる　mountsNameも地域に応じたものに変更する
            selectedRegion = item1!
            selectedMounts = extract(selectedRegion,mountLoc)// 地域に応じた山のデータ・・・ここの戻り値 filterd は正しい
            
            print("selectedRegion③:\(selectedRegion)") //OK
            print("selectedMounts③:\(selectedMounts)") //OK
            //print("selectedMounts\(selectedMounts)") //　いまのところ、すべての山のデータを表示している
            
        } else {
            if (picker.tag == 2){ //ここで、地域名に応じた山名を表示するようにする
                let row2 = mountPickerView.selectedRow(inComponent: 0)//コンポーネント１内の行番号
                choice = row2 // 選択した項目の番号
                let item2 = self.pickerView(mountPickerView, titleForRow: row2, forComponent: 0)//山名？？？不明
                
                print("selectedMounts③\(selectedMounts)")
                print("row2③:\(row2)")
                print("item2③!\(item2!)")

            }
        }
        //mountLocをselectedMountsに変えてみた・・・良い結果が得られたが、ドラムロール２への表示がでない
//        UserDefaults.standard.set(mountLoc[choice][2], forKey: "mtName") //[2]山名
//        UserDefaults.standard.set(mountLoc[choice][3], forKey: "mtLatitude") //[3]緯度保存
//        UserDefaults.standard.set(mountLoc[choice][4], forKey: "mtLongitude") //[4]経度保存
        UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName") //[2]山名
        UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude") //[3]緯度保存
        UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude") //[4]経度保存
    }
 
    // 二重配列から、特定の要素を含む配列を取り出して、新しい二重配列をつくる ----------------------
    // 地域名に応じた山のデータ配列を抜き出す　word:検索する地域名、Array:検索対象の配列
    func extract(_ word:String ,_ Array:[[String]]) -> [[String]] {
        var filtered:[[String]] = []//　ドラムロールで選択した"地域名"を含む。抽出した配列
        var j = 0 // ループカウンタ
        for array in mountLoc { //山のデータ配列[番号、地域名、山名、緯度、経度]
            // array[1]:２番目の要素（地域名）だけ調べる
            if array[1] == selectedRegion { //取り出した要素が、検索値に等しい時
                filtered.append(array)
            }
            j = j + 1
        }
        print("filterd:\(filtered)")
        return filtered
    }
    //---------------------------------------------------------------------------------
    
}


