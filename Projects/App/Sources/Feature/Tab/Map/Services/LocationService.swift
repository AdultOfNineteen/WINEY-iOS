//
//  LocationService.swift
//  MapFeature
//
//  Created by 박혜운 on 1/31/24.
//

import CoreLocation
import Combine
import Foundation

//final class LocationDataManager: NSObject {
//  
//  // MARK: - Properties
//  
//  private let locationManager = CLLocationManager()
//  
//  // 권한 상태
//  var authorizationStatus: CLAuthorizationStatus {
//    locationManager.authorizationStatus
//  }
//  
//  // 사용자의 현재 위치
//  var currentCoordinates: Coordinates? {
//    guard let location = locationManager.location else { return nil }
//    
//    return Coordinates(
//      latitude: location.coordinate.latitude,
//      longitude: location.coordinate.longitude
//    )
//  }
//  
//  // 권한 변경 publisher
//  let didChangeAuthorization = PassthroughSubject<CLAuthorizationStatus, Never>()
//  
//  // MARK: - Singleton
//  
//  static let shared = LocationDataManager()
//  
//  private override init() {
//    super.init()
//    locationManager.delegate = self
//  }
//}
//
//// MARK: - CLLocationManagerDelegate
//
//extension LocationDataManager: CLLocationManagerDelegate {
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    if case .notDetermined = manager.authorizationStatus {
//      locationManager.requestWhenInUseAuthorization()
//      return
//    }
//    
//    didChangeAuthorization.send(manager.authorizationStatus)
//  }
//}

//class LocationManager: NSObject, CLLocationManagerDelegate {
//  static let shared = LocationManager()
//  let locationManager = CLLocationManager() // private 처리 할 것 
//  private var authorizationContinuation: CheckedContinuation<String?, Never>?
//  
//  private override init() {
//    super.init()
//    locationManager.delegate = self
//  }
//  
//  func requestLocationAuthorization() { // 권한 요청 
//    locationManager.requestWhenInUseAuthorization()
//  }
//  
//  
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    switch manager.authorizationStatus {
//    case .authorizedWhenInUse, .authorizedAlways:
//      // 권한이 허용된 경우의 처리
//      break
//    case .denied, .restricted:
//      // 권한이 거부된 경우의 처리
//      break
//    case .notDetermined:
//      locationManager.startUpdatingLocation()
//      // 권한이 아직 결정되지 않은 경우의 처리
//      break
//    default:
//      break
//    }
//  }
//}
