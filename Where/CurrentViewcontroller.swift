//
//  CurrentViewcontroller.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/03.
//

import UIKit
import MapKit
import CoreLocation

// MKPolylineクラスの拡張　３色の線を引くため
//最初に、MKPolylineクラスを拡張する2つのクラスを作成する
fileprivate class FujiOverlay:MKPolyline{}
fileprivate class TreeOverlay:MKPolyline{}
fileprivate class AddOverlay:MKPolyline{} // 追加した山への線を紫色で引く


class CurrentViewController: ViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    // Mapを使用する
    @IBOutlet weak var mapView: MKMapView!
    // ロケーションマネージャーのインスタンス
    var locManager: CLLocationManager!
    
    //======================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager = CLLocationManager()
        locManager.delegate = self
 
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //誤差100m程度の精度
        //kCLLocationAccuracyNearestTenMeters    誤差10m程度の精度
        //kCLLocationAccuracyBest    最高精度(デフォルト値)
        locManager.distanceFilter = 5//精度は5ｍにしてみた

        // 位置情報の使用の許可を得て、取得する
        locManager.requestWhenInUseAuthorization()

        locationManagerDidChangeAuthorization(locManager)
            //authorizationStatus() がdeprecated になったため、上のメソッドで対応している
        }
    
    //======================================================
    //authorizationStatus() がdeprecated になったため、下のメソッドで対応している
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
     let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locManager.startUpdatingLocation()// 取得を開始する
            break
        case .notDetermined, .denied, .restricted:
            break
        default:
            break
        }
    }
    
    // CLLocationManagerのdelegate：現在位置取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        //現在地の緯度経度取得 ido,keido
        let location:CLLocation = locations[0]//locations[0]の意味
        let ido = location.coordinate.latitude
        let keido = location.coordinate.longitude

        //"mapView"に地図を表示する
        let compass = MKCompassButton(mapView: mapView) // コンパス
        compass.frame = CGRect(x:300,y:15,width:5,height:5) // 位置と大きさ
        self.view.addSubview(compass)// コンパスを地図に表示する
        mapView.userTrackingMode = .followWithHeading // 現在地付近の地図
        mapView.delegate = self
        
        // ここから線を引く部分。
        // 現在地と富士山と東京スカイツリーの座標を指定する
        let locNow = CLLocationCoordinate2D(latitude: ido, longitude: keido)
        let locFuji = CLLocationCoordinate2D(latitude: 35.3625, longitude: 138.7306)
        let locTree = CLLocationCoordinate2D(latitude: 35.710139, longitude: 139.810833)
        
        // 追加した山名、緯度経度を読み込む
        let mtName = UserDefaults.standard.string(forKey: "mtName")//山名読み込み
print(mtName!)
        let mtLatitude = UserDefaults.standard.double(forKey: "mtLatitude")//緯度読み込み
print(mtLatitude)
        let mtLongitude = UserDefaults.standard.double(forKey: "mtLongitude")//経度読み込み
print(mtLongitude)
        let locAdd = CLLocationCoordinate2D(latitude: mtLatitude , longitude: mtLongitude )
        
        let arrFuji = [locNow,locFuji]// 現在地と富士山を入れた配列
        let arrTree = [locNow,locTree]// 現在地とスカイツリーを入れた配列
        let arrAdd = [locNow,locAdd]// 現在地と追加した山を入れた配列
        
        let fujiLine = FujiOverlay(coordinates: arrFuji, count: 2)// ２点を結ぶ
        mapView.addOverlays([fujiLine])// 地図上に描く 現在地ー富士山
        let treeLine = TreeOverlay(coordinates: arrTree, count: 2)// ２点を結ぶ
        mapView.addOverlays([treeLine])// 地図上に描く 現在地ースカイツリー
        let addLine = AddOverlay(coordinates: arrAdd, count: 2)// ２点を結ぶ
        if mtLatitude != 0 {
            mapView.addOverlays([addLine])// 地図上に描く 現在地ー追加した山
        }
        
        
    }

    // ポリライン(オーバーレイ)がどちらのクラスのものか、switch-case文で３つに分ける
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
            switch overlay {
                case is FujiOverlay:
                    renderer.strokeColor = UIColor.red// 赤い線　富士山
                    renderer.lineWidth = 2
                case is TreeOverlay:
                    renderer.strokeColor = UIColor.blue//青い線　スカイツリー
                    renderer.lineWidth = 2
                case is AddOverlay:
                    renderer.strokeColor = UIColor.purple//紫の線　追加した山
                    renderer.lineWidth = 2
                default:
                    break
            }
        return renderer
    }
    
    
}
