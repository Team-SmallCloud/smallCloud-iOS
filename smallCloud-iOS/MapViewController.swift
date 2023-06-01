//
//  MapViewController.swift
//  smallCloud-iOS
//
//  Created by 김만 on 2023/06/01.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, MTMapViewDelegate {

    var mapView:MTMapView!
    var locationManager:CLLocationManager!
    
    var la : Double!
    var lo : Double!
    
    let defaultLatitude: Double = 37.6314191
    let defaultLongitude: Double = 127.0548249
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        la = locationManager.location?.coordinate.latitude
        lo = locationManager.location?.coordinate.longitude
        
        let myMapCenter = MTMapPoint(geoCoord: MTMapPointGeo(latitude: la ?? defaultLatitude, longitude: lo ?? defaultLongitude))
        
        // 현재 위치를 한글로 변환
        let LocationNow = CLLocation(latitude: la ?? defaultLatitude, longitude: lo ?? defaultLongitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(LocationNow, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address:[CLPlacemark] = placemarks {
                if let country : String = address.last?.country {print(country)}
                if let adminstrativeArea : String = address.last?.administrativeArea {print(adminstrativeArea)}
                if let locality : String = address.last?.locality {print(locality)}
                if let name : String = address.last?.name {print(name)}
            }
        })
        
        
        

        mapView = MTMapView(frame: CGRect(x: 0, y: 50, width: 450, height: 780))
        //mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        // 지도 중심 좌표 설정
        mapView.setMapCenter(myMapCenter, animated: true)
        self.view.addSubview(mapView)
        

        // Do any additional setup after loading the view.
    }
    
}

extension MapViewController:CLLocationManagerDelegate{
    func getLocationUsagePermission(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case.authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location: CLLocation = locations[locations.count-1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
    }
    
}

