//
//  MapViewController.swift
//  smallCloud-iOS
//
//  Created by 김만 on 2023/06/01.
//

import UIKit
import CoreLocation

//카카오RESTAPI를 사용하기위해
import Alamofire
import SwiftyJSON

public struct Place{
        let placeName :String
        let roadAdressName:String
        let longitudeX:String
        let latitudeY:String
    }
    
var resultList=[Place]()


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
        
        // 현재 위치 트래킹
        mapView.currentLocationTrackingMode = .onWithoutHeading
        mapView.showCurrentLocationMarker = true
        
        //createPin2(itemNames: "현위치", getla: la, getlo: lo, customImageName: "user-gps-marker")
        
        addAnimalHospitalMarkers()
        // Do any additional setup after loading the view.
    }
    
    
    //func createPin(itemNames: String, getla:Double, getlo:Double, markerType: MTMapPOIItemMarkerType) -> MTMapPOIItem {
    //    let poiItem = MTMapPOIItem()
    //    poiItem.itemName = "\(itemNames)"
    //    poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo))
    //
    //    poiItem.markerType = markerType
    //
    //    mapView.addPOIItems([poiItem])
    //    return poiItem
    //}


    func createPin2(itemNames: String, getla: Double, getlo: Double, customImageName: String) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = itemNames
        poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo))
        
        poiItem.markerType = .customImage
        poiItem.customImageName = customImageName
        
        mapView.addPOIItems([poiItem])
        return poiItem
    }

    
    
}


extension MapViewController:CLLocationManagerDelegate{
//    func getLocationUsagePermission(){
//        self.locationManager.requestWhenInUseAuthorization()
//    }
    
    func getLocationUsagePermission() {
            DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
            }
        }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정")
                // 필요한 동작 수행
                locationManager.startUpdatingLocation()
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
    
    
//    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
//        switch status {
//        case.authorizedAlways, .authorizedWhenInUse:
//            print("GPS 권한 설정")
//        case .restricted, .notDetermined:
//            print("GPS 권한 설정되지 않음")
//            getLocationUsagePermission()
//        case .denied:
//            print("GPS 권한 요청 거부")
//            getLocationUsagePermission()
//        default:
//            print("GPS: Default")
//        }
//    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location: CLLocation = locations[locations.count-1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
    }
    
    //카카오RESTAPI
    func addAnimalHospitalMarkers() {
        guard let currentLocation = locationManager.location?.coordinate else {
                return
            }
           let animalHospitalAPIURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
                "Authorization": "KakaoAK 07897825ca4d62b2f12ae645b244d091"
            ]
        let parameters: Parameters = [
                    "query": "동물병원",
                    "x": currentLocation.longitude,
                    "y": currentLocation.latitude
                ]
        
        
        AF.request(animalHospitalAPIURL, parameters: parameters, headers: headers).responseJSON { response in
            print(response) // 응답 출력
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let documents = json["documents"].arrayValue

                        for document in documents {
                            if let placeName = document["place_name"].string,
                               let roadAddressName = document["road_address_name"].string,
                               let longitudeX = document["x"].string,
                                let latitudeY = document["y"].string
                                {
                                let place = Place(placeName: placeName, roadAdressName: roadAddressName, longitudeX: longitudeX, latitudeY: latitudeY)
                                resultList.append(place)

                                self.addMarkerToKakaoMap(place: place)
                            }
                        }

                    case .failure(let error):
                        print(error)
                    }
                }
            }
            func addMarkerToKakaoMap(place: Place) {
            let marker = MTMapPOIItem()
            marker.itemName = place.placeName
            marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(place.latitudeY) ?? 0.0, longitude: Double(place.longitudeX) ?? 0.0))
            
            marker.markerType = .customImage
            marker.customImageName = "animal-hospital-marker"

            mapView.addPOIItems([marker])
                print("Added marker: \(place.placeName)") // 마커 추가 로그 출력
        }
    
}

