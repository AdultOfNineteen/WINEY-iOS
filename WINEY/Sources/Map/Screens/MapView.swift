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
  @Bindable var store: StoreOf<Map>
  
  public init(
    store: StoreOf<Map>
  ) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack {
        NaverMapView()
      }
      
      blackTopGradientBackground
      
      if store.filterCategory == .all && !store.mapSheet.isNavigationActive {
        VStack {
          ShopCategoryListTap(
            isTappedCategory:
                .init(
                  get: { store.filterCategory },
                  set: {
                    value in store.send(.tapped(category: value))
                  }
                )
          )
          Spacer()
        }
        .padding(.top, 84)
        
      } else {
        VStack {
          ZStack(alignment: .bottom) {
            Color.wineyGray900.opacity(0.7)
            ZStack(alignment: .bottom) {
              HStack {
                Button(
                  action: {
                    store.send(
                      .mapSheet(.tappedNavigationBackButton)
                    )
                  },
                  label: {
                    Image(.navigationBack_buttonW)
                  }
                )
                Spacer()
              }
              .padding(.leading, 17)
              
              if store.mapSheet.destination == .shopDetail {
                Text(store.mapSheet.tappedShopInfo?.name ?? "음식점")
                  .wineyFont(.title2)
              } else {
                Text(
                  store.filterCategory.title
                )
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
    .onAppear {
      store.send(._viewWillAppear)
    }
    .ignoresSafeArea()
    .shopBottomSheet(
      height: .init(
        get: { store.sheetHeight },
        set: { height in store.send(._changeBottomSheet(height: height)) }
      ),
      presentProgress: .init(
        get: { store.setProgressView },
        set: { value in store.send(._activeProgressView(value)) }
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
        store.send(.tappedReloadCurrentMap)
      },
      label: {
        ZStack {
          RoundedRectangle(cornerRadius: 42)
            .fill(.wineyGray50)
            .frame(width: 133, height: 35)
          
          HStack(spacing: 10) {
            Text("현위치에서 검색")
              .wineyFont(.captionB1)
              .foregroundColor(.wineyMain2)
            
            Image(.location_reloadW)
          }
        }
      }
    )
  }
  
  var shopListBottomSheetUpButton: some View {
    Button(
      action: {
        store.send(.tappedListButtonToBottomSheetUp
        )
      },
      label: {
        ZStack {
          RoundedRectangle(cornerRadius: 42)
            .fill(.wineyGray900)
            .frame(width: 105, height: 35)
          
          HStack(spacing: 10) {
            Text("목록 열기")
              .wineyFont(.captionB1)
              .foregroundColor(
                .wineyGray50
              )
            
            Image(.map_listW)
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
        store.send(.tappedCurrentUserLocationMarker)
      },
      label: {
        Circle()
          .fill(.wineyGray900)
          .frame(width: 48, height: 48)
          .overlay {
            Image(.location_trackerW)
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
