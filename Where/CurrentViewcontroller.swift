//
//  CurrentViewcontroller.swift
//  Where
//
//  Created by 森部高昌 on 2021/08/03.
//

import UIKit
import MapKit
import CoreLocation

class CurrentViewController: ViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    // Mapを使用する
    @IBOutlet weak var mapView: MKMapView!
    // ロケーションマネージャーのインスタンス
    var locManager: CLLocationManager!
    
    
    
}
