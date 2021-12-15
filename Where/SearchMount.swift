//
//  SearchMount.swift
//  Where
//
//  Created by 森部高昌 on 2021/12/11.
//  山の配列データをcsvファイルから読み込む。[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]
//  山のデータを配列に入れる
//  ①searchBarに検索する山名を入力する
//  ②
//  ③返ってきた値をtableViewに表示する。
//  ④tableViewで選択したcellから、山名・緯度・経度を取得する


import UIKit

class SearchMountController: UIViewController, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchText: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    // tableViewは、datasouce、delegateをviewControllerとの接続も必要。右クリックして確認できる
    var findItems = [FindItem]() // FindItem　別クラスの配列。返ってきた値をtableViewに表示するために使う
    
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
            
            return dataArray
            // dataArray = [[ふりがな,山名,緯度,経度,高度,都道府県名,山域名,地理院地図へのリンク]] 二重配列
        }


    // ＝＝＝＝＝＝　以下　SearchBarとtableView 関係　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    //-----------------------------------------------------------------------------
        // searchBarへの入力に対する処理
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //キーボードを閉じる
            view.endEditing(true)
            if let searchWord = searchBar.text {
                print("①検索山名:\(searchWord)") // searchBarに入力した山名の表示
                //入力されていたら、山名を検索する
                searchMount(keyword: searchWord)
            }
        }
  
    //-----------------------------------------------------------------------------
        // 山名の検索  searchMountメソッド 第一引数：keyword 検索したい語句
        func searchMount(keyword:String) {
            print("searchMountの中")
            findItems = []
            for data in originalMountDatas { //originalMountDatasから、１件ずつdataに取り出して調べる
                //print(data)
                if data[0] == keyword { //ふりがなの部分が一致したとき
                    self.findItems.append(FindItem()) // tableViewに表示する配列に追加

                    print("data:\(data)")//
                    print("data[0]:\(data[0])")
                    print("FindItem():\(FindItem())")
                    print("findItems:\(self.findItems)")
                    print("self.findItems.count:\(self.findItems.count)")

//                    let lastItem = self.findItems[self.findItems.count - 1]
//                    let tmpString = lastItem.mountName
//                    print("tmpString:\(tmpString!)")

//                    if self.findItems.count > 0 {//
//                        //let lastItem = self.findItems[self.findItems.count - 1]
//                        //let tmpString = lastItem.mountName
//
//                    }
                }
            }
                //self.findItems.append(FindItem()) // tableViewに表示する配列に追加//
                //let tmpString = lastItem.mountName
                // lastItem.mountName = (tmpString != nil) ? tmpString! + string : string
                // print("mountName:\(string)") // 確認用
                //let lastItem = self.findItems[self.findItems.count - 1]//
            self.tableView.reloadData() //tableViewへ表示する
        }
    
    //-----------------------------------------------------------------------------
    
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
                    cell.textLabel?.text = findItem.mountName // 検索結果　山名の表示
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
        var phonetic:String! //よみがな
        var mountName:String! //山名
        var latitude: String! //緯度
        var longitude: String! //経度
        var height:String! //高さ
        var prefecture:String! //都道府県名
        var region:String! //山域名
        var link:String! //地理院地図へのリンク
        }

