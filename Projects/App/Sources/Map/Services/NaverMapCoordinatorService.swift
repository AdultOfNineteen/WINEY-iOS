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
  
  public var updateUserLocationInMap: (_ lat: Double, _ lng: Double) -> Void
  
  public var tappedMarker: @Sendable ([ShopMapDTO]) async -> AsyncStream<Int>
  
  public var getCameraCenterPosition: () -> MapPosition
  
  public var getCameraAnglePostion: () -> MapCameraAnglePosition
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
      updateUserLocationInMap: { lat, lng in
        naverMapCoordinator.fetchUserLocation(lat, lng)
      },
      tappedMarker: { shopList in
        await naverMapCoordinator.setShopMarker(shopList)
      },
      getCameraCenterPosition: {
        return naverMapCoordinator.getCameraCenterPosition()
      },
      getCameraAnglePostion: {
        return naverMapCoordinator.getCameraAnglePostion()
      }
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
  NMFMapViewTouchDelegate
{
  
  static let shared = NaverMapCoordinator()
  
  private let view = NMFNaverMapView(frame: .zero)
  private var markers: [NMFMarker] = []
  private var clickedMarkerContinuation: AsyncStream<Int>.Continuation?
  
  private override init() {
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
  
  func getNaverMapView() -> NMFNaverMapView {
    view
  }
  
  @MainActor
  fileprivate func setShopMarker(_ shopList: [ShopMapDTO]) -> AsyncStream<Int> {
    markers.forEach({ $0.mapView = nil })
    markers = []
    
    if shopList.isEmpty {
      return .finished
    } else {
      for shop in shopList {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: shop.latitude, lng: shop.longitude)
        marker.mapView = view.mapView
        marker.iconImage = NMFOverlayImage(name: shop.shopMarkerType.imageTitle)
        marker.width = 29 // 닷
        marker.height = 29
        marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
          
        // MARK: - 마커 탭 이미지 미적용 (디자이너에게 탭 마커 이미지 요청)
        //    marker.iconImage = NMFOverlayImage(name: "clicked_marker") // 마커 탭 시 이미지 미적용
        //    marker.width = 43.29 // 닷
        //    marker.height = 63
          
          self?.clickedMarkerContinuation?.yield(shop.id)
          return true
        }
        markers.append(marker)
      }
      
      return setTappedMarkerEvent()
    }
  }
  
  fileprivate func getCameraCenterPosition() -> MapPosition {
    let centerLat = view.mapView.cameraPosition.target.lat
    let centerLng = view.mapView.cameraPosition.target.lng
    
    return .init(latitude: centerLat, longitude: centerLng)
  }
  
  fileprivate func getCameraAnglePostion() -> MapCameraAnglePosition {
    let southWest = view.mapView.projection.latlngBounds(fromViewBounds: self.view.frame).southWest // 남서
    let northEast = view.mapView.projection.latlngBounds(fromViewBounds: self.view.frame).northEast // 북동
    
    return .init(
      leftTopLatitude: northEast.lat, leftTopLongitude: southWest.lng, // 북서
      rightBottomLatitude: southWest.lat, rightBottomLongitude: northEast.lng // 동남
    )
  }

  fileprivate func fetchUserLocation(_ lat: Double, _ lng: Double) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 15)
    cameraUpdate.animation = .easeIn
    cameraUpdate.animationDuration = 1
    
    let locationOverlay = view.mapView.locationOverlay
    locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
    locationOverlay.hidden = false
    
    locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
    locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
    locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
    locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
    
    view.mapView.positionMode = .direction
    view.mapView.moveCamera(cameraUpdate)
  }
  
  private func setTappedMarkerEvent() -> AsyncStream<Int> {
    return AsyncStream<Int> { continuation in
      self.clickedMarkerContinuation = continuation
    }
  }
}

extension NaverMapCoordinator {
  enum MapConstants {
    static let dotMarkerSize: (widht: CGFloat, height: CGFloat) = (29, 29)
    static let clickedMarkerSize: (widht: CGFloat, height: CGFloat) = (43.29, 63)
    static let dotMarkerImageName: String = "dot_marker"
    static let clickedMarkerImageName: String = "clicked_marker"
  }
}
