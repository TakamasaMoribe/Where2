//
//  CurrentViewcontroller.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/03.
//

import UIKit
import MapKit
import CoreLocation

// MKPolylineクラスの拡張　２色の線を引くため
//最初に、MKPolylineクラスを拡張する2つのクラスを作成する
fileprivate class FujiOverlay:MKPolyline{}
fileprivate class TreeOverlay:MKPolyline{}


class CurrentViewController: ViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
 
    @IBOutlet weak var testLabel: UILabel!
    
    // Mapを使用する
    @IBOutlet weak var mapView: MKMapView!
    // ロケーションマネージャーのインスタンス
    var locManager: CLLocationManager!
    
    //======================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "ためし"

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
        
        let arrFuji = [locNow,locFuji]// 現在地と富士山を入れた配列
        let arrTree = [locNow,locTree]// 現在地とスカイツリーを入れた配列
        
        let fujiLine = FujiOverlay(coordinates: arrFuji, count: 2)// ２点を結ぶ
        mapView.addOverlays([fujiLine])// 地図上に描く 現在地ー富士山
        let treeLine = TreeOverlay(coordinates: arrTree, count: 2)// ２点を結ぶ
        mapView.addOverlays([treeLine])// 地図上に描く 現在地ースカイツリー
    }

    // ポリライン(オーバーレイ)がどちらのクラスのものか、場合分けして２通りの色で線を引く
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        if overlay is FujiOverlay {
            renderer.strokeColor = UIColor.red// 赤い線
            renderer.lineWidth = 2
        } else {
            renderer.strokeColor = UIColor.blue// 青い線
            renderer.lineWidth = 2
        }
        return renderer
    }
    
    
}
