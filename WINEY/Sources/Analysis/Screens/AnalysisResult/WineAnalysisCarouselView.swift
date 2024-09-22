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
  
  public init(store: StoreOf<WineAnalysisCarousel>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollViewReader { proxy in
      VStack(spacing: 0) {
        GeometryReader { geometry in
          ScrollView {
            LazyVStack(spacing: 0) {
              wineRebuyView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(0)
              
              winePreferNationView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(1)
              
              winePreferCategoryView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(2)
              
              winePreferTasteView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(3)
              
              winePreferSmellView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(4)
              
              winePriceView()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(5)
            }
          }
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .scrollDisabled(true)
          .simultaneousGesture(
            DragGesture()
              .onEnded { gesture in
                store.send(.dragGesture(gesture))
                proxy.scrollTo(store.state.pageIndex, anchor: .center)
              }
          )
        }
        
        bottomArrow()
          .onTapGesture {
            store.send(.tappedArrow)
            proxy.scrollTo(store.state.pageIndex, anchor: .center)
          }
      }
    }
  }
  
}

private extension WineAnalysisCarouselView {
  
  @ViewBuilder
  func wineRebuyView() -> some View {
    WineAnalysisPieChartView(
      store: Store(
        initialState: store.state.winePieChart,
        reducer: {
          WineAnalysisPieChart()
        }
      ))
  }
  
  @ViewBuilder
  func winePreferNationView() -> some View {
    WinePreferNationView(
      store: Store(
        initialState: store.state.wineNation,
        reducer: {
          WinePreferNation()
        }
      )
    )
  }
  
  @ViewBuilder
  func winePreferCategoryView() -> some View {
    WinePreferCategoryView(
      store: Store(
        initialState: store.state.wineCategory,
        reducer: {
          WinePreferCategory()
        }
      )
    )
  }
  
  @ViewBuilder
  func winePreferTasteView() -> some View {
    WinePreferTasteView(
      store: Store(
        initialState: store.state.wineTaste,
        reducer: {
          WinePreferTaste()
        }
      )
    )
  }
  
  @ViewBuilder
  func winePreferSmellView() -> some View {
    WinePreferSmellView(
      store: Store(
        initialState: store.state.wineSmell,
        reducer: {
          WinePreferSmell()
        }
      )
    )
  }
  
  @ViewBuilder
  func winePriceView() -> some View {
    WinePriceView(
      store: Store(
        initialState: store.state.winePrice,
        reducer: {
          WinePrice()
        }
      )
    )
  }
  
  @ViewBuilder
  func bottomArrow() -> some View {
    Group {
      if store.pageIndex == 5 {
        Image(.arrowTopW)
      } else {
        Image(.arrowBottomW)
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
