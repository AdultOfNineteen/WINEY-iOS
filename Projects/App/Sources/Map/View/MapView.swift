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
      
      if viewStore.filterCategory == .all {
        VStack {
          ShopCategoryListTap(
            isTappedCategory:
              viewStore.binding(
                get: \.filterCategory,
                send: Map.Action.tapped(category: )
              )
          )
          Spacer()
        }
        .padding(.top, 84)
        .padding(.horizontal, 22)
      } else {
        VStack {
          ZStack(alignment: .bottom) {
            WineyKitAsset.gray900.swiftUIColor.opacity(0.7)
            ZStack(alignment: .bottom) {
              HStack {
                Button(
                  action: {
                    viewStore.send(.tappedNavigationBackButton)
                  },
                  label: {
                    WineyAsset.Assets.navigationBackButton.swiftUIImage
                  }
                )
                Spacer()
              }
              .padding(.leading, 17)
              
              Text(viewStore.filterCategory.title)
                .wineyFont(.title2)
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
        VStack {
          Spacer()
            .frame(height: 30)
          ScrollView {
            VStack {
              ForEach(viewStore.shopList.indices) { index in
                ShopListCell(
                  viewStore.shopList[index].info,
                  isBookMarked: viewStore.binding(
                    get: \.shopList[index].info.like,
                    send: Map.Action.tappedBookMark(index: index)
                  )
                )
                .onTapGesture {
                  viewStore.send(.tappedShopListCell)
                }
              }
              .padding(
                .horizontal,
                WineyGridRules
                  .globalHorizontalPadding
              )
            }
            .navigationDestination(
              isPresented:
                viewStore.binding(
                  get: \.moveNavigation,
                  send: Map.Action._moveNavigationView
                ),
              destination: {
                ZStack {
                  VStack {
                    ForEach(viewStore.shopList.indices)
                    { index in
                      ShopDetailCell(
                        shopInfo: viewStore.shopList[index].info,
                        isBookmarked: viewStore.binding(
                          get: \.shopList[index].info.like,
                          send: Map.Action.tappedBookMark(
                            index: index
                          )
                        ),
                        presentBusinessHourAction: { isTapped in
                          viewStore.send(
                            .tappedShopBusinessHour(isTapped)
                          )
                        }
                      )
                    }
                    Spacer()
                  }
                }
                .navigationBarBackButtonHidden()
                .background(
                  viewStore.sheetHeight == .close ?
                  WineyKitAsset.gray900.swiftUIColor : WineyKitAsset.gray950.swiftUIColor
                )
              }
            )
          }
        }
      }
    )
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
