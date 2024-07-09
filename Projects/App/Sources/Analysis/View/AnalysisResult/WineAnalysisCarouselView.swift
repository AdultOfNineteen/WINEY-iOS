//
//  TestView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisCarouselView: View {
  private let store: StoreOf<WineAnalysisCarousel>
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysisCarousel>
  
  public init(store: StoreOf<WineAnalysisCarousel>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollViewReader { proxy in
        ZStack {
          ScrollView {
            LazyVStack(spacing: 0) {
              WineAnalysisPieChartView(
                store: Store(
                  initialState: viewStore.state.winePieChart,
                  reducer: {
                    WineAnalysisPieChart()
                  }
                ))
              .frame(width: geometry.size.width, height: geometry.size.height)
              .id(0)
              
              WinePreferNationView(
                store: Store(
                  initialState: viewStore.state.wineNation,
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
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
          .scrollDisabled(true)
          .simultaneousGesture(
            DragGesture()
              .onEnded { gesture in
                viewStore.send(.dragGesture(gesture))
                proxy.scrollTo(viewStore.state.pageIndex, anchor: .center)
              }
          )
          
          bottomArrow()
            .onTapGesture {
              viewStore.send(.tappedArrow)
              proxy.scrollTo(viewStore.state.pageIndex, anchor: .center)
            }
        }
      }
    }
  }
}

extension WineAnalysisCarouselView {
  
  @ViewBuilder
  private func bottomArrow() -> some View {
    VStack {
      Spacer()
      
      if viewStore.pageIndex == 5 {
        WineyAsset.Assets.arrowTop.swiftUIImage
      } else {
        WineyAsset.Assets.arrowBottom.swiftUIImage
      }
    }
    .padding(.bottom, 64)
  }
}


public struct PreView: PreviewProvider {
  static let data = TasteAnalysisDTO(
    recommendCountry: "",
    recommendVarietal: "",
    recommendWineType: "",
    totalWineCnt: 3,
    buyAgainCnt: 7,
    topThreeTypes: [],
    topThreeCountries: [],
    topThreeVarieties: [],
    topSevenSmells: [],
    taste: Taste(
      sweetness: 0,
      acidity: 0,
      alcohol: 0,
      body: 0,
      tannin: 0,
      finish: 0
    ),
    avgPrice: 30000
  )
  
  public static var previews: some View {
    WineAnalysisCarouselView(
      store: Store(
        initialState: WineAnalysisCarousel.State.init(
          data: self.data
        ),
        reducer: {
          WineAnalysisCarousel()
        }
      )
    )
  }
}
