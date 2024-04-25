//
//  LocationService.swift
//  MapFeature
//
//  Created by 박혜운 on 1/31/24.
//

import CoreLocation
import Dependencies

struct LocationService {
  var checkIfLocationServiceIsEnabled: () async -> (Bool)
  var userLocation: () -> (lat: Double, lng: Double)?
  
}

extension LocationService {
  static let live = {
    let locationManager = LocationManager.shared
    
    return Self(
      checkIfLocationServiceIsEnabled: {
        return await locationManager.checkIfLocationServiceIsEnabled()
      }, 
      userLocation: {
        return locationManager.getUserLocation()
      }
    )
  }()
}

extension LocationService: DependencyKey {
  public static var liveValue = Self.live
}

extension DependencyValues {
  var location: LocationService {
    get { self[LocationService.self] }
    set { self[LocationService.self] = newValue }
  }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  private var locationManager: CLLocationManager?
  
  private override init() {
    super.init()
  }
  
  // Coordinator 클래스 안의 코드
  func checkIfLocationServiceIsEnabled() async -> Bool { // 최초실행 시 한 번
    return await withCheckedContinuation { continuation in
      if CLLocationManager.locationServicesEnabled() { // 위치접근 허용인지
        Task { @MainActor in
          self.locationManager = CLLocationManager()
          self.locationManager?.delegate = self
          let result =  await self.checkLocationAuthorization() // 허용이라면 어떤 단계인지
          continuation.resume(returning: result)
        }
      }
      else {
        print("Show an alert letting them know this is off and to go turn i on")
        continuation.resume(returning: false)
      }
    }
  }
  
  func getUserLocation() -> (lat: Double, lng: Double)? {
    if let locationManager = locationManager,
    let location = locationManager.location
    {
      let coordinate = location.coordinate
      return (coordinate.latitude, coordinate.longitude)
    } else {
      return nil
    }
  }
  
  // MARK: - 위치 정보 동의 확인
  private func checkLocationAuthorization() async -> Bool {
    guard let locationManager = locationManager else { return false }
    return await withCheckedContinuation { continuation in
      switch locationManager.authorizationStatus {
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .restricted:
        print("위치 정보 접근이 제한되었습니다.")
      case .denied:
        print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
      case .authorizedAlways, .authorizedWhenInUse:
        print("Success")
        continuation.resume(returning: true)
        return
      @unknown default: break
      }
      continuation.resume(returning: false)
    }
  }
  
  
}
