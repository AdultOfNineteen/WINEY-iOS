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

public struct NaverMapCoordinatorService {
  public var getShopsInfoOf: (
    _ shopCategory: ShopCategoryType,
    _ latitude: Double,
    _ longitude: Double,
    _ leftTopLatitude: Double,
    _ leftTopLongitude: Double,
    _ rightBottomLatitude: Double,
    _ rightBottomLongitude: Double
  ) async -> Result<[ShopMapDTO], Error>
  
  public var toggleBookMark: (
    _ shopId: Int
  ) async -> Result<VoidResponse, Error>
  
  public var updateUserLocationInMap: () -> ()
  
  public var tappedMarker: @Sendable ([ShopMapDTO]) async -> AsyncStream<Int>
}

extension NaverMapCoordinatorService {
  static let live = {
    let naverMapCoordinator = NaverMapCoordinator.shared
    
    return Self(
      getShopsInfoOf: {
        shopCategory,
        latitude, longitude,
        leftTopLatitude, leftTopLongitude, rightBottomLatitude, rightBottomLongitude in
        return await Provider<MapAPI>
          .init()
          .request(
            MapAPI.shops(
              shopCategory: shopCategory,
              latitude: latitude,
              longitude: longitude,
              leftTopLatitude: leftTopLatitude,
              leftTopLongitude: leftTopLongitude,
              rightBottomLatitude: rightBottomLatitude,
              rightBottomLongitude: rightBottomLongitude
            ),
            type: [ShopMapDTO].self
          )
      },
      toggleBookMark: { shopId in
        return await Provider<MapAPI>
          .init()
          .request(
            MapAPI.bookmark(shopId: shopId),
            type: VoidResponse.self
          )
      }, 
      updateUserLocationInMap: {
        naverMapCoordinator.fetchUserLocation()
      },
      tappedMarker: { shopList in
        await naverMapCoordinator.setShopMarker(shopList)
      }
//      ,
//      cameraMovement: {
//        naverMapCoordinator.cameraMovement()
//        
//      }
    )
  }()
  //  static let mock = Self(…)
  //  static let unimplemented = Self(…)
}

extension NaverMapCoordinatorService: DependencyKey {
  public static var liveValue = NaverMapCoordinatorService.live
}

extension DependencyValues {
  var naverCoordinator: NaverMapCoordinatorService {
    get { self[NaverMapCoordinatorService.self] }
    set { self[NaverMapCoordinatorService.self] = newValue }
  }
}

public final class NaverMapCoordinator:
  NSObject,
  NMFMapViewCameraDelegate,
  NMFMapViewTouchDelegate,
  CLLocationManagerDelegate {
  
  static let shared = NaverMapCoordinator()
  
  let view = NMFNaverMapView(frame: .zero)
  private var clickedMarkerContinuation: AsyncStream<Int>.Continuation?
  
  enum MapConstants {
    static let dotMarkerSize: (widht: CGFloat, height: CGFloat) = (29, 29)
    static let clickedMarkerSize: (widht: CGFloat, height: CGFloat) = (43.29, 63)
    static let dotMarkerImageName: String = "dot_marker"
    static let clickedMarkerImageName: String = "clicked_marker"
  }
  
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
  
  @MainActor
  public func setShopMarker(_ shopList: [ShopMapDTO]) -> AsyncStream<Int> {
    for shop in shopList {
      let marker = NMFMarker()
      marker.position = NMGLatLng(lat: shop.latitude, lng: shop.longitude)
      marker.mapView = view.mapView
      marker.iconImage = NMFOverlayImage(name: shop.shopMarkerType.imageTitle)
      marker.width = 29 // 닷
      marker.height = 29
      
      marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
//        marker.iconImage = NMFOverlayImage(name: "clicked_marker")
//        marker.width = 43.29 // 닷
//        marker.height = 63
        self?.clickedMarkerContinuation?.yield(shop.id)
        return true
      }
    }
    
    return setTappedMarkerEvent()
  }
  
  private func setTappedMarkerEvent() -> AsyncStream<Int> {
    return AsyncStream<Int> { continuation in
      self.clickedMarkerContinuation = continuation
    }
  }
  
//  public func cameraMovement() -> AsyncStream<Void> {
//    return AsyncStream<Void> { continuation in
//      // Continuation을 저장하여 mapView delegate 메소드에서 이벤트를 방출할 수 있도록 합니다.
//      self.cameraMovementContinuation = continuation
//    }
//  }
  
//  public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//    // 카메라 이동이 시작되기 전 호출되는 함수
//  }
//  
//  public func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//    // 카메라의 위치가 변경되면 호출되는 함수
////    cameraMovementContinuation?.yield(())
//  }
  
  
  
//  public func mapViewCameraIdle(_ mapView: NMFMapView) {
////    cameraMovedAction()
//    // 여기서 API 호출 뒤 마커 뷰 깔기 위해 뷰 갱신
////    debounceWorkItem?.cancel() // 이전에 예약된 작업이 있다면 취소
////    let workItem = DispatchWorkItem { [weak self] in // 새로운 작업 생성
//    self.cameraMovementContinuation?.yield(()) // 이벤트 전달
////    }
////    
////    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
////    
////    debounceWorkItem = workItem 
//    // 1. 현 지도 위치의 음식점들 API 메서드 호출
//    // 2. 마커뷰 세팅 메서드 호출
//  }
  
  var locationManager: CLLocationManager?
  
  // MARK: - 위치 정보 동의 확인
  func checkLocationAuthorization() async -> Bool {
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
  func checkIfLocationServiceIsEnabled() async -> Bool {
    print("1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣1️⃣")
    return await withCheckedContinuation { continuation in
      print("2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣2️⃣")
      if CLLocationManager.locationServicesEnabled() {
        print("3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣3️⃣")
        Task { @MainActor in
          print("4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣4️⃣")
          //      DispatchQueue.main.async {
          self.locationManager = CLLocationManager()
          self.locationManager!.delegate = self
          print("5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣5️⃣")
          let result =  await self.checkLocationAuthorization()
          print("6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣6️⃣")
          continuation.resume(returning: result)
          print("\(result) 결과 값은??????")
        }
      }
      else {
        print("Show an alert letting them know this is off and to go turn i on")
        continuation.resume(returning: false)
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
      
      view.mapView.positionMode = .direction
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  func getNaverMapView() -> NMFNaverMapView {
    view
  }
}
