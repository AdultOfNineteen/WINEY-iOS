//
//  MapTestView.swift
//  MapFeature
//
//  Created by 박혜운 on 1/31/24.
//

import ComposableArchitecture
import CoreLocation
import NMapsMap
import SwiftUI
import WineyKit

public struct MapView: View {
  private let store: StoreOf<Map>
  @ObservedObject var viewStore: ViewStoreOf<Map>
  
  public init(store: StoreOf<Map>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    ZStack {
      VStack {
        NaverMapView()
      }
      
      blackTopGradientBackground
      
      if viewStore.filterCategory == .all && !viewStore.mapSheet.isNavigationActive {
        VStack {
          ShopCategoryListTap(
            isTappedCategory:
              viewStore.binding(
                get: \.filterCategory,
                send: {
                  Map.Action.tapped(category: $0)
                }
              )
          )
          Spacer()
        }
        .padding(.top, 84)
        
      } else {
        VStack {
          ZStack(alignment: .bottom) {
            WineyKitAsset.gray900.swiftUIColor.opacity(0.7)
            ZStack(alignment: .bottom) {
              HStack {
                Button(
                  action: {
                    viewStore.send(.mapSheet(.tappedNavigationBackButton))
                  },
                  label: {
                    WineyAsset.Assets.navigationBackButton.swiftUIImage
                  }
                )
                Spacer()
              }
              .padding(.leading, 17)
              
              if viewStore.mapSheet.destination == .shopDetail {
                Text(viewStore.mapSheet.tappedShopInfo?.info.name ?? "음식점")
                  .wineyFont(.title2)
              } else {
                Text(viewStore.filterCategory.title)
                  .wineyFont(.title2)
              }
            }
            .frame(height: 68)
          }
          .frame(height: 118)
          
          Spacer()
        }
      }
      
      VStack {
        reloadMapButton
        Spacer()
      }
      .padding(.top, 142)
      
      VStack {
        Spacer()
        shopListBottomSheetUpButton
      }
      .padding(.bottom, 176)
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          replacingCameraUserCurrentLocationButton
          Spacer()
            .frame(width: 24)
        }
      }
      .padding(.bottom, 169)
    }
    .ignoresSafeArea()
    .onAppear {
      viewStore.send(._onAppear)
    }
    .shopBottomSheet(
      height: viewStore.binding(
        get: \.sheetHeight,
        send: Map.Action._changeBottomSheet
      ),
      presentProgress: viewStore.binding(
        get: \.setProgressView,
        send: Map.Action._activeProgressView
      ),
      content: {
        MapSheetView(
          store: store
            .scope(
              state: \.mapSheet,
              action: Map.Action.mapSheet
            )
        )
      }
    )
  }
}

// MARK: - Extension

extension MapView {
  var blackTopGradientBackground: some View {
    VStack {
      LinearGradient(
        colors: [
          .black.opacity(0.40),
          .black.opacity(0.30),
          .black.opacity(0.20),
          .clear
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(height: 140)
      
      Spacer()
    }
  }
  
  var reloadMapButton: some View {
    Button(
      action: {
        viewStore.send(.tappedReloadCurrentMap)
      },
      label: {
        ZStack {
          RoundedRectangle(cornerRadius: 42)
            .fill(WineyKitAsset.gray50.swiftUIColor)
            .frame(width: 133, height: 35)
          
          HStack(spacing: 10) {
            Text("현위치에서 검색")
              .wineyFont(.captionB1)
              .foregroundColor(WineyKitAsset.main2.swiftUIColor)
            
            WineyAsset.Assets.locationReload.swiftUIImage
          }
        }
      }
    )
  }
  
  var shopListBottomSheetUpButton: some View {
    Button(
      action: {
        viewStore.send(.tappedListButtonToBottomSheetUp)
      },
      label: {
        ZStack {
          RoundedRectangle(cornerRadius: 42)
            .fill(WineyKitAsset.gray900.swiftUIColor)
            .frame(width: 105, height: 35)
          
          HStack(spacing: 10) {
            Text("목록 열기")
              .wineyFont(.captionB1)
              .foregroundColor(
                WineyKitAsset.gray50.swiftUIColor
              )
            
            WineyAsset.Assets.mapList.swiftUIImage
              .resizable()
              .frame(width: 13, height: 12)
          }
        }
      }
    )
  }
  
  var replacingCameraUserCurrentLocationButton: some View {
    Button(
      action: {
        viewStore.send(.tappedCurrentUserLocationMarker)
      },
      label: {
        Circle()
          .fill(WineyKitAsset.gray900.swiftUIColor)
          .frame(width: 48, height: 48)
          .overlay {
            WineyAsset.Assets.locationTracker.swiftUIImage
              .resizable()
              .frame(width: 22, height: 22)
          }
      }
    )
  }
}

#Preview {
  MapView(
    store: .init(
      initialState: .init(),
      reducer: { Map() }
    )
  )
}
