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
    VStack(spacing: 0) {
      NavigationBar(
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        }
      )
      
      VStack(spacing: 0) {
        // Top 고정 문구
        VStack {
          Group {
            Text("이런 와인은 어때요?")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            
            Text("\"" + viewStore.wineRecommend + "\"")
              .foregroundColor(WineyKitAsset.main3.swiftUIColor)
              .multilineTextAlignment(.center)
              .padding(.top, 39)
          }
          .wineyFont(.title2)
        }
        .padding(.top, 39)
        .padding(.horizontal, 24)
        
        WineAnalysisResultScrollView()
      }
    }
    .background(Color(red: 31/255, green: 33/255, blue: 38/255))
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarHidden(true)
  }
  
  public var circleGraphView: some View {
    VStack {
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Text("지금까지")
            .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          Text("\(viewStore.wineCount)개의 와인을 마셨고,")
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
        }
        
        HStack(spacing: 0) {
          Text("\(viewStore.wineRepurchase)개의 와인에 대해 재구매")
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          Text("의향이 있어요!")
            .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
        }
      }
      .wineyFont(.captionM1)
      
      Spacer()
      
      WineyAsset.Assets.arrowBottom.swiftUIImage
        .padding(.bottom, 64)
    }
  }
}


public struct WineAnalysisResultScrollView: View {
  public var body: some View {
    GeometryReader { geo in
      ScrollView {
        WinePreferNationView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferCategoryView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferTasteView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferSmellView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePriceView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
      }
    }
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
