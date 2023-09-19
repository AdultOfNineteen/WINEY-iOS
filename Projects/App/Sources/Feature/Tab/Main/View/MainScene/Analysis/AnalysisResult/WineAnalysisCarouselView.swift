//
//  TestView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct WineAnalysisCarouselView: View {
  private let store: StoreOf<WineAnalysisCarousel>
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysisCarousel>
  
  public init(store: StoreOf<WineAnalysisCarousel>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    GeometryReader { geometry in
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack {
            WineAnalysisInitView()
              .frame(width: geometry.size.width, height: geometry.size.height)
              .id(0)
            
            WinePreferNationView(
              store: Store(
                initialState: WinePreferNation.State.init(),
                reducer: {
                  WinePreferNation()
                }
              )
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(1)
            
            WinePreferCategoryView(
              store: Store(
                initialState: viewStore.state.wineCategory,
                reducer: {
                  WinePreferCategory()
                })
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(2)
            
            WinePreferTasteView(
              store: Store(
                initialState: viewStore.state.wineTaste,
                reducer: {
                  WinePreferTaste()
                })
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(3)
            
            WinePreferSmellView(
              store: Store(
                initialState: viewStore.state.wineSmell,
                reducer: {
                  WinePreferSmell()
                })
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(4)
            
            WinePriceView(
              store: Store(
                initialState: viewStore.state.winePrice,
                reducer: {
                  WinePrice()
                })
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(5)
          }
        }
        .scrollDisabled(true)
        .simultaneousGesture(
          DragGesture()
            .onEnded { gesture in
              viewStore.send(.dragGesture(gesture))
              proxy.scrollTo(viewStore.state.pageIndex, anchor: .center)
            }
        )
      }
    }
  }
}


public struct PreView: PreviewProvider {
  public static var previews: some View {
    WineAnalysisCarouselView(
      store: Store(
        initialState: WineAnalysisCarousel.State.init(),
        reducer: {
          WineAnalysisCarousel()
        }
      )
    )
  }
}
