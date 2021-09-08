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
fileprivate class RedOverlay:MKPolyline{}
fileprivate class BlueOverlay:MKPolyline{}
fileprivate class GreenOverlay:MKPolyline{} // 追加した山への線を紫色で引く


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

        //"mapView"に地図を表示する　よくある範囲設定をしてみた
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        let compass = MKCompassButton(mapView: mapView) // コンパス
        compass.frame = CGRect(x:300,y:15,width:5,height:5) // 位置と大きさ
        self.view.addSubview(compass)// コンパスを地図に表示する
        mapView.userTrackingMode = .followWithHeading // 現在地付近の地図
        mapView.delegate = self
        
        // ここから線を引く部分。
        // 現在地の座標を指定する
        let locNow = CLLocationCoordinate2D(latitude: ido, longitude: keido)
        //let locFuji = CLLocationCoordinate2D(latitude: 35.3625, longitude: 138.7306)
        //let locTree = CLLocationCoordinate2D(latitude: 35.710139, longitude: 139.810833)
        
        // 追加した山名１〜３について、緯度経度を読み込む・・・・メソッドにする？？
//        let mtName1 = UserDefaults.standard.string(forKey: "mtName1")//山名読み込み
        let mtLatitude1 = UserDefaults.standard.double(forKey: "mtLatitude1")//緯度読み込み
        let mtLongitude1 = UserDefaults.standard.double(forKey: "mtLongitude1")//経度読み込み
//        let mtName2 = UserDefaults.standard.string(forKey: "mtName2")
        let mtLatitude2 = UserDefaults.standard.double(forKey: "mtLatitude2")
        let mtLongitude2 = UserDefaults.standard.double(forKey: "mtLongitude2")
//        let mtName3 = UserDefaults.standard.string(forKey: "mtName3")
        let mtLatitude3 = UserDefaults.standard.double(forKey: "mtLatitude3")
        let mtLongitude3 = UserDefaults.standard.double(forKey: "mtLongitude3")
        
        
//            }
        let locMount1 = CLLocationCoordinate2D(latitude: mtLatitude1 , longitude: mtLongitude1 )
        let locMount2 = CLLocationCoordinate2D(latitude: mtLatitude2 , longitude: mtLongitude2 )
        let locMount3 = CLLocationCoordinate2D(latitude: mtLatitude3 , longitude: mtLongitude3 )
        
        let arrMount1 = [locNow,locMount1]// 現在地と目的地１を入れた配列
        let arrMount2 = [locNow,locMount2]// 現在地と目的地２を入れた配列
        let arrMount3 = [locNow,locMount3]// 現在地と目的地３を入れた配列
        
        let redLine = RedOverlay(coordinates: arrMount1, count: 2)// ２点を結ぶ
        mapView.addOverlays([redLine])// 地図上に描く
        let blueLine = BlueOverlay(coordinates: arrMount2, count: 2)
        mapView.addOverlays([blueLine])
        let greenLine = GreenOverlay(coordinates: arrMount3, count: 2)
        mapView.addOverlays([greenLine])
    }

    // ポリライン(オーバーレイ)がどちらのクラスのものか、switch-case文で３つに分ける
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
            switch overlay {
                case is RedOverlay:
                    renderer.strokeColor = UIColor.red// 赤い線
                    renderer.lineWidth = 2
                case is BlueOverlay:
                    renderer.strokeColor = UIColor.blue//青い線　スカイツリー
                    renderer.lineWidth = 2
                case is GreenOverlay:
                    renderer.strokeColor = UIColor.purple//紫の線　追加した山
                    renderer.lineWidth = 2
                default:
                    break
            }
        return renderer
    }
    
    
}
