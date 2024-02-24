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
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysisResult>
  
  public init(store: StoreOf<WineAnalysisResult>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        VStack {
          Spacer()
          
          WineAnalysisCarouselView(
            store: Store(
              initialState: viewStore.carouselList,
              reducer: {
                WineAnalysisCarousel()
              }
            )
          )
          .frame(width: geo.size.width, height: geo.size.height - 221)
        }
        
        VStack(spacing: 0) {
          NavigationBar(
            leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
            leftIconButtonAction: {
              viewStore.send(.tappedBackButton)
            },
            backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
          )
          
          VStack(spacing: 0) {
            Text("이런 와인은 어때요?")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            
            if let country = viewStore.recommendCountry, 
                let varietal = viewStore.recommendVarietal,
               let type = viewStore.recommendWineType {
              Text("\"" + "\(country)의 \(varietal) 품종으로 만든\n\(WineType.changeType(at: type).korName) 와인" + "\"")
                .multilineTextAlignment(.center)
                .padding(.top, 39)
                .foregroundStyle(WineyKitAsset.main3.swiftUIColor)
            }
          }
          .wineyFont(.title2)
          .padding(.top, 39)
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .background(WineyKitAsset.mainBackground.swiftUIColor)
    
          Rectangle()
            .opacity(0)
        }
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
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
