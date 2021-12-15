//
//  SearchMount.swift
//  Where
//
//  Created by 森部高昌 on 2021/12/11.
//  山の配列データをcsvファイルから読み込む。[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]
//  あらかじめ五十音順にしておくべきか？
//  山のデータを配列に入れる
//  ①searchBarに検索する山名を入力する
//  ②
//  ③返ってきた値をtableViewに表示する。
//  ④tableViewで選択したcellから、山名・緯度・経度を取得する


import UIKit

class SearchMountController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var searchText: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    // tableViewは、datasouce、delegateをviewControllerとの接続も必要。右クリックして確認できる
    // feedUrl：searchBarに入力した地名を問い合わせるのに使う
    // var feedUrl:URL = URL(string:"https://geocode.csis.u-tokyo.ac.jp/cgi-bin/simple_geocode.cgi")! //東大

//    var feedUrl:URL = URL(string:"Dummy")! //初期化 何か入れていないとエラーになるので、とりあえずDummyとした
    var findItems = [FindItem]() // FindItem　別クラスの配列。返ってきた値をtableViewに表示するために使う
//    var currentElementName:String! // 返ってきた値をパースしている最中に、読み出している項目名
    
// -------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //山の配列データをcsvファイルから読み込む。[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]
        originalMountDatas = dataLoad()
        
        searchText.delegate = self
        searchText.placeholder = "検索する地名を入力してください"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        // csvファイルから、山のデータを読み込む　"MountData.csv"
        func dataLoad() -> [[String]] {
            // データを格納するための配列を準備する
            var dataArray :[[String]] = [] // 二重配列にして、空配列にしておく
            // データの読み込み準備 ファイルが見つからないときは実行しない
            guard let thePath = Bundle.main.path(forResource: "MountData", ofType: "csv") else {
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
            print(dataArray[1])
            print(dataArray[1][1])
            if let result = dataArray[1][0].firstIndex(of: "お") {
            print("result:\(result)")
            } else {
                print("nil")
            }
            return dataArray
            // dataArray = [[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]] 二重配列
        }
        
//    //------------------------------- いらない？？？
//        // 山名だけ取り出した配列をつくる。（ドラムロールに山名だけを表示するため）
//        func setMountsName(mountData:[[String]]) -> [String]{
//            let mountCount = mountData.count // 山の数
//            var mountsName:[String] = [] // 山名を取り出す配列　最初の宣言はいらない
//                for i in 0...mountCount-1 {
//                    mountsName.append(mountData[i][2]) //山名は、配列内の３番目[番号、地域名、山名、緯度、経度]
//                }
//            return mountsName // 山名の配列を返す
//        }
        
//    //------------------------------- ----- いらない？？？
//        // 二重配列から、特定の要素を含む配列を取り出して、新しい二重配列をつくる
//        func extract(_ word:String ,_ Array:[[String]]) -> [[String]] {
//            var filtered:[[String]] = [] // ドラムロールで選択した"地域名"が含まれる行だけの配列
//            var j = 0 // ループカウンタ
//            for array in originalMountDatas { //山のデータ配列[番号、地域名、山名、緯度、経度]
//                // array[1]:２番目の要素（地域名）だけ調べる
//                if array[1] == selectedRegion { //取り出した要素が、選択した地域名に等しい時
//                    filtered.append(array)
//                }
//                j = j + 1
//            }
//            return filtered
//        }
        
    //-------------------------------
//        // 山名を選択したら、赤・青・紫の線を引く山の名前を設定し、緯度・経度のデータを保存する
//        func targetMountain()   {
//            let row2 = mountPickerView.selectedRow(inComponent: 0)//コンポーネント１内の行番号
//            choice = row2 // ドラムロール２で選択した項目の番号
//            if redButton.isChecked == false {
//                firstRedLabel.text = selectedMounts[choice][2] // 赤線で引く山名を表示する
//                redButton.isChecked = true
//                UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName1") //山名保存
//                UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude1") //緯度保存
//                UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude1") //経度保存
//
//            }else {
//                if blueButton.isChecked == false {
//                    secondBlueLabel.text = selectedMounts[choice][2] // 青線
//                    blueButton.isChecked = true
//                    UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName2")
//                    UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude2")
//                    UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude2")
//                }else {
//                    if purpleButton.isChecked == false {
//                        thirdPurpleLabel.text = selectedMounts[choice][2] // 紫線
//                        purpleButton.isChecked = true
//                        UserDefaults.standard.set(selectedMounts[choice][2], forKey: "mtName3")
//                        UserDefaults.standard.set(selectedMounts[choice][3], forKey: "mtLatitude3")
//                        UserDefaults.standard.set(selectedMounts[choice][4], forKey: "mtLongitude3")
//                    }else {
//                    //
//                    }
//                }
//            }
//        }
//
//
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝　以下　SearchBarとtableView 関係　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    
    //-----------------------------------------------------------------------------
        // searchBarへの入力に対する処理
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //キーボードを閉じる
            view.endEditing(true)
            if let searchWord = searchBar.text {
                print("①検索地名:\(searchWord)") // キーボードからsearchBarに入力した地名の表示 ①
            //入力されていたら、地名を検索する
                //searchPlace(keyword: searchWord)// 別のルーチンを使う  // searchMount とでも名付ける
            }
        }
    
            
//            // 地名の検索  searchPlaceメソッド 第一引数：keyword 検索したい語句
//            func searchPlace(keyword:String) {
//                // keyword をurlエンコードする
//                guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//                    return
//                }
//                // keyword_encode を使って、リクエストurlを組み立てる
//                guard let req_url = URL(string: "https://geocode.csis.u-tokyo.ac.jp/cgi-bin/simple_geocode.cgi?addr=\(keyword_encode)") else {
//                    return
//                }
//
//                feedUrl = req_url // パースするときに使っている
//                print("②feedUrl:\(feedUrl)")//入力されていたら、アドレスを表示する。
//                //feedUrlの中身をパースする  パーサーは使わない
//                    //print("パース開始")
//                    //let parser: XMLParser! = XMLParser(contentsOf: feedUrl)
//                    //parser.delegate = self
//                    //parser.parse()
//                self.tableView.reloadData() //tableViewへ表示する
//            }
            
    //-----------------------------------------------------------------------------
            
//            //タグの最初が見つかったとき呼ばれる
//            func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//                self.currentElementName = nil // 初期化
//                if elementName == "mountName" {
//                    currentElementName = "mountName" //
// ●                   self.findItems.append(findItem()) // tableViewに表示する配列に追加//・・・・・・・いる
//                } else {
//                   currentElementName = elementName
//                }
//            }
//
//            // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド。stringが得られる
//             func parser(_ parser: XMLParser, foundCharacters string: String) {
//
//                 if string != "\n" { // 改行でなければ読み取る
//
// ●                    if self.findItems.count > 0 {//・・・・・・・いる
// ●                        let lastItem = self.findItems[self.findItems.count - 1]//・・・・・・・いる
//
//                        switch self.currentElementName {
//                         case "mountName":
//                             let tmpString = lastItem.mountName
//                             lastItem.mountName = (tmpString != nil) ? tmpString! + string : string
//                             print("mountName:\(string)") // 確認用
//                         case "longitude":
//                             let tmpString = lastItem.longitude
//                             lastItem.longitude = (tmpString != nil) ? tmpString! + string : string
//                             print("longitude:\(string)") // 確認用
//                         case "latitude":
//                             let tmpString = lastItem.latitude
//                             lastItem.latitude = (tmpString != nil) ? tmpString! + string : string
//                             print("latitude:\(string)") // 確認用
//                         default:
//                             break
//                        }
//                    }
//                 }
//             }
//
//            // タグの終わりが見つかったとき呼ばれる
//            func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//                //print("タグの終わり\(elementName)")
//            }
//
//            // sent when the parser has completed parsing. If this is encountered, the parse was successful.
//            func parserDidEndDocument(_ parser: XMLParser) {
//                print("パース終了")
//            }

            
    // tableView への表示・セルの選択----------------------------------------
            // 行数の取得
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.findItems.count
            }

            // セルへの表示
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
                let findItem = self.findItems[indexPath.row]
                    cell.textLabel?.text = findItem.mountName // 検索結果　住所の表示
                return cell
            }

            // セルを選択したとき
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let findItem = self.findItems[indexPath.row]
                print("選択した地点:\(findItem.mountName!)") //確認用
                print("選択した地点:\(findItem.longitude!)") //確認用
                print("選択した地点:\(findItem.latitude!)") //確認用
                // 選択した地点のデータを保存する
                let userDefaults = UserDefaults.standard
                userDefaults.set(findItem.mountName!, forKey: "selectmountName")
                userDefaults.set(findItem.longitude!, forKey: "selectLongitude")
                userDefaults.set(findItem.latitude!, forKey: "selectLatitude")
                
                // ①storyboardのインスタンス取得
                let storyboard: UIStoryboard = self.storyboard!
                // ②遷移先ViewControllerのインスタンス取得
                let nextView = storyboard.instantiateViewController(withIdentifier: "CurrentViewController") as! CurrentViewController
                // ③画面遷移
                self.present(nextView, animated: true, completion: nil)
                
            }
            
        }


    // ============================================================//
    class FindItem {
        //[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]
        var ruby:String! //よみがな
        var mountName:String! //山名
        var latitude: String! //緯度
        var longitude: String! //経度
        var height:String! //高さ
        var prefecture:String! //都道府県名
        var region:String! //山域名
        var link:String! //地理院地図へのリンク
        }

