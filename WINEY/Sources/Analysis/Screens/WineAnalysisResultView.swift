//
//  WineAnalysisResultView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisResultView: View {
  private let store: StoreOf<WineAnalysisResult>
  
  public init(store: StoreOf<WineAnalysisResult>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .wineyMainBackground
      )
      
      VStack(spacing: 0) {
        Text("이런 와인은 어때요?")
          .foregroundColor(.wineyGray50)
        
        if let country = store.recommendCountry,
          let varietal = store.recommendVarietal,
          let type = store.recommendWineType {
          Text("\"" + "\(country)의 \(varietal) 품종으로 만든 \(WineType.changeType(at: type).korName) 와인" + "\"")
            .multilineTextAlignment(.center)
            .padding(.top, 39)
            .foregroundStyle(.wineyMain3)
        }
      }
      .wineyFont(.title2)
      .padding(.top, 39)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .background(.wineyMainBackground)
      
      WineAnalysisCarouselView(
        store: Store(
          initialState: store.carouselList,
          reducer: {
            WineAnalysisCarousel()
          }
        )
      )
    }
    .background(.wineyMainBackground)
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarHidden(true)
  }
}

public struct WineAnalysisResultView_Previews:
  PreviewProvider {
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
      sparkling: 0,
      finish: 0
    ),
    avgPrice: 30000
  )
  
  public static var previews: some View {
    WineAnalysisResultView(
      store: Store(
        initialState: WineAnalysisResult.State
          .init(
            data: data
          ),
          reducer: {
            WineAnalysisResult()
          }
      )
    )
  }
}
