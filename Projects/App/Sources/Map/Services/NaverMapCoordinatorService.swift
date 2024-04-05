//
//  NaverMapCoordinatorService.swift
//  Winey
//
//  Created by 박혜운 on 2/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Dependencies
import NMapsMap
import SwiftUI
import WineyKit
import WineyNetwork

// MARK: - Dependency에 추가할 계획

//public struct NaverMapCoordinatorService {
//  public var getShopsInfoOf: (
//    _ shopCategory: ShopCategoryType,
//    _ latitude: Double,
//    _ longitude: Double,
//    _ leftTopLatitude: Double,
//    _ leftTopLongitude: Double,
//    _ rightBottomLatitude: Double,
//    _ rightBottomLongitude: Double
//  ) async -> Result<[ShopMapDTO], Error>
//  
//  public var toggleBookMark: (
//    _ shopId: Int
//  ) async -> Result<VoidResponse, Error>
//}
//
//extension NaverMapCoordinatorService {
//  static let live = {
//    return Self(
//      getShopsInfoOf: {
//        shopCategory,
//        latitude, longitude,
//        leftTopLatitude, leftTopLongitude, rightBottomLatitude, rightBottomLongitude in
//        return await Provider<MapAPI>
//          .init()
//          .request(
//            MapAPI.shops(
//              shopCategory: shopCategory,
//              latitude: latitude,
//              longitude: longitude,
//              leftTopLatitude: leftTopLatitude,
//              leftTopLongitude: leftTopLongitude,
//              rightBottomLatitude: rightBottomLatitude,
//              rightBottomLongitude: rightBottomLongitude
//            ),
//            type: [ShopMapDTO].self
//          )
//      },
//      toggleBookMark: { shopId in
//        return await Provider<MapAPI>
//          .init()
//          .request(
//            MapAPI.bookmark(shopId: shopId),
//            type: VoidResponse.self
//          )
//      }
//    )
//  }()
//  //  static let mock = Self(…)
//  //  static let unimplemented = Self(…)
//}
//
//extension NaverMapCoordinatorService: DependencyKey {
//  public static var liveValue = MapService.live
//}
//
//extension DependencyValues {
//  var naverCoordinator: NaverMapCoordinatorService {
//    get { self[NaverMapCoordinatorService.self] }
//    set { self[NaverMapCoordinatorService.self] = newValue }
//  }
//}

public final class NaverMapCoordinator:
  NSObject,
  NMFMapViewCameraDelegate,
  NMFMapViewTouchDelegate,
  CLLocationManagerDelegate {
  
  static let shared = NaverMapCoordinator()
  
  let view = NMFNaverMapView(frame: .zero)
  
  public override init() {
    super.init()
    
    view.mapView.positionMode = .direction
    view.mapView.isNightModeEnabled = true
    
    view.mapView.zoomLevel = 15
    view.mapView.minZoomLevel = 10 // 최소 줌 레벨
    view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
    
    view.showLocationButton = true
    view.showZoomControls = false // 줌 확대, 축소 버튼 활성화
    view.showCompass = false
    view.showScaleBar = false
    
    view.mapView.addCameraDelegate(delegate: self)
    view.mapView.touchDelegate = self
  }
  
  public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    // 카메라 이동이 시작되기 전 호출되는 함수
  }
  
  public func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    // 카메라의 위치가 변경되면 호출되는 함수
    
  }
  
  var locationManager: CLLocationManager?
  
  // MARK: - 위치 정보 동의 확인
  func checkLocationAuthorization() {
    guard let locationManager = locationManager else { return }
    
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      print("위치 정보 접근이 제한되었습니다.")
    case .denied:
      print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
    case .authorizedAlways, .authorizedWhenInUse:
      print("Success")
      
//      coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
//      userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
//      
//      fetchUserLocation()
      
    @unknown default:
      break
    }
  }
  
  func getCameraCenterPosition() -> MapPosition {
    let centerLat = view.mapView.cameraPosition.target.lat
    let centerLng = view.mapView.cameraPosition.target.lng
    
    return .init(latitude: centerLat, longitude: centerLng)
  }
  
  func getCameraAnglePostion() -> MapCameraAnglePosition {
    let southWest = view.mapView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest // 남서
    let northEast = view.mapView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast // 북동
    
    return .init(
      leftTopLatitude: northEast.lat, leftTopLongitude: southWest.lng, // 북서
      rightBottomLatitude: southWest.lat, rightBottomLongitude: northEast.lng // 동남
    )
  }
  
  // Coordinator 클래스 안의 코드
  func checkIfLocationServiceIsEnabled() {
    DispatchQueue.global().async {
      if CLLocationManager.locationServicesEnabled() {
        DispatchQueue.main.async {
          self.locationManager = CLLocationManager()
          self.locationManager!.delegate = self
          self.checkLocationAuthorization()
        }
      } else {
        print("Show an alert letting them know this is off and to go turn i on")
      }
    }
  }
  
  func fetchUserLocation() {
    if let locationManager = locationManager {
      let lat = locationManager.location?.coordinate.latitude
      let lng = locationManager.location?.coordinate.longitude
      let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
      cameraUpdate.animation = .easeIn
      cameraUpdate.animationDuration = 1
      
      let locationOverlay = view.mapView.locationOverlay
      locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
      locationOverlay.hidden = false
      
      locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
      locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
      locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
      locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
      
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  func getNaverMapView() -> NMFNaverMapView {
    view
  }
}
