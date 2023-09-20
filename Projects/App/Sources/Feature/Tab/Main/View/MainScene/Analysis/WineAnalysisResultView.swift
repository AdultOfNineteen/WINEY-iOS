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
          .frame(width: geo.size.width, height: geo.size.height-221)
        }
        
        VStack(spacing: 0) {
          NavigationBar(
            leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
            leftIconButtonAction: {
              viewStore.send(.tappedBackButton)
            }
          )
          
          VStack(spacing: 0) {
            Group {
              Text("이런 와인은 어때요?")
                .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
              
              Text("\"" + viewStore.wineRecommend + "\"")
                .foregroundColor(WineyKitAsset.main3.swiftUIColor)
                .frame(width: geo.size.width - 48, height: 60)
                .multilineTextAlignment(.center)
                .padding(.top, 39)
            }
            .wineyFont(.title2)
          }
          .padding(.top, 39)
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          .background(Color(red: 31/255, green: 33/255, blue: 38/255))
    
          Rectangle()
            .opacity(0)
        }
      }
    }
    .background(Color(red: 31/255, green: 33/255, blue: 38/255))
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarHidden(true)
  }
}

public struct WineAnalysisResultView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisResultView(
      store: Store(
        initialState: WineAnalysisResult.State.init(),
          reducer: {
            WineAnalysisResult()
          }
      )
    )
  }
}
