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
  @Bindable var store: StoreOf<MapSheet>
  
  public init(store: StoreOf<MapSheet>) {
    self.store = store
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      ScrollView {
        VStack(spacing: 0) {
          if store.selectedCategory == .myPlace {
            BottomSheetCategoryTitle(
              title: store.selectedCategory.title,
              savesShopCount: "\(store.shopList.count)"
            )
            .padding(.top, 23)
            
            Divider()
              .padding(.top, 18)
          }
          
          if store.shopList.isEmpty {
            VStack {
              Spacer()
                .frame(height: store.selectedCategory == .myPlace ? 31.5 : 128)
              
              EmptyListInfoView(type: store.selectedCategory == .myPlace ? .bookmark : .shop)
              Spacer()
            }
          } else {
            cellList
              .padding(.bottom, 100)
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
        store.shopList,
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
          store.send(
            .tappedShopListCell(
              id: shop.id
            )
          )
        }
        Divider()
      }
      .navigationDestination(
        isPresented: $store.isNavigationActive,
        destination: {
          VStack(spacing: 0) {
            Spacer()
              .frame(height: 25)
            ShopDetailCell(
              shopInfo: store.tappedShopInfo ?? .dummy,
              isBookmarked: .init(
                get: {
                  store.tappedShopInfo?.like ?? false
                },
                set: { _ in
                  store.send(.tappedBookMark(
                    id: store
                      .tappedShopInfo?.id ?? 0
                    )
                  )
                }
              ),
              
              presentBusinessHourAction: { isTapped in
                store.send(
                  .tappedShopBusinessHour(isTapped)
                )
              }
            )
            Spacer()
          }
          .navigationBarBackButtonHidden()
          .background(.wineyGray950)
        }
      )
    }
    .navigationBarBackButtonHidden()
    .background(.wineyGray950)
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
