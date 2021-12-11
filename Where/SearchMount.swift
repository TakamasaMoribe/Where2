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
//  ④tableViewで選択したcellから、地名・緯度・経度を取得する


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
        searchText.delegate = self
        searchText.placeholder = "検索する地名を入力してください"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //-----------------------------------------------------------------------------
        // searchBarへの入力に対する処理
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //キーボードを閉じる
            view.endEditing(true)
            if let searchWord = searchBar.text {
                print("①検索地名:\(searchWord)") // キーボードからsearchBarに入力した地名の表示 ①
            //入力されていたら、地名を検索する
                //searchPlace(keyword: searchWord)// 別のルーチンを使う
                // searchMount とでも名付ける
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
//                if elementName == "address" {
//                    currentElementName = "address" //
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
//                         case "address":
//                             let tmpString = lastItem.address
//                             lastItem.address = (tmpString != nil) ? tmpString! + string : string
//                             print("address:\(string)") // 確認用
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
                    cell.textLabel?.text = findItem.address // 検索結果　住所の表示
                return cell
            }

            // セルを選択したとき
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let findItem = self.findItems[indexPath.row]
                print("選択した地点:\(findItem.address!)") //確認用
                print("選択した地点:\(findItem.longitude!)") //確認用
                print("選択した地点:\(findItem.latitude!)") //確認用
                // 選択した地点のデータを保存する
                let userDefaults = UserDefaults.standard
                userDefaults.set(findItem.address!, forKey: "selectAddress")
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
        var address: String!
        var longitude: String!
        var latitude: String!
        }

