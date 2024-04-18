//
//  ShopBottomSheetBaseView.swift
//  Winey
//
//  Created by 박혜운 on 3/26/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct MapSheetView: View {
  private let store: StoreOf<MapSheet>
  @ObservedObject var viewStore: ViewStoreOf<MapSheet>
  
  public init(store: StoreOf<MapSheet>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      ScrollView {
        VStack(spacing: 0) {
          if viewStore.selectedCategory == .myPlace {
            BottomSheetCategoryTitle(
              title: viewStore.selectedCategory.title,
              savesShopCount: "\(viewStore.shopList.count)"
            )
            .padding(.top, 23)
            
            Divider()
              .padding(.top, 18)
          }
          
          if viewStore.shopList.isEmpty {
            EmptyListInfoView()
          } else {
            cellList
          }
        }
      }
    }
  }
  
  @ViewBuilder
  @MainActor
  var cellList: some View {
    VStack(spacing: 0) {
      ForEach(
        viewStore.shopList,
        id: \.self.id
      ) { shop in
        ShopListCell(
          info: shop,
          isBookMarked:
            .init(
              get: { shop.like },
              set: { _ in
                store.send(
                  .tappedBookMark(id: shop.id)
                )
              }
            )
        )
        .frame(height: 158)
        .onTapGesture {
          viewStore.send(
            .tappedShopListCell(
              id: shop.id
            )
          )
        }
        Divider()
      }
      .navigationDestination(
        isPresented: viewStore.$isNavigationActive,
        destination: {
          VStack {
            ShopDetailCell(
              shopInfo: viewStore.tappedShopInfo ?? .dummy,
              isBookmarked: .init(
                get: {
                  viewStore.tappedShopInfo?.like ?? false
                },
                set: { _ in
                  viewStore.send(.tappedBookMark(
                    id: viewStore
                      .tappedShopInfo?.id ?? 0
                    )
                  )
                }
              ),
              
              presentBusinessHourAction: { isTapped in
                viewStore.send(
                  .tappedShopBusinessHour(isTapped)
                )
              }
            )
            Spacer()
          }
          .navigationBarBackButtonHidden()
          .background(WineyKitAsset.gray950.swiftUIColor)
        }
      )
    }
    .navigationBarBackButtonHidden()
    .background(WineyKitAsset.gray950.swiftUIColor)
    .padding(
      .horizontal,
      WineyGridRules
        .globalHorizontalPadding
    )
  }
}

#Preview {
  ZStack(alignment: .top) {
    MapSheetView(
      store: .init(
        initialState: MapSheet.State(
          selectedCategory: .bottleShop,
          shopList: [.dummy, .dummy2]),
        reducer: { MapSheet() }
      )
    )
    .frame(height: 676)
  }
}
