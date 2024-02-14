//
//  WineAnalysisLoading.swift
//  Winey
//
//  Created by 정도현 on 2023/09/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisLoadingView: View {
  private let store: StoreOf<WineAnalysisLoading>
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysisLoading>
  
  public init(store: StoreOf<WineAnalysisLoading>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      ZStack(alignment: .center) {
        WineyAsset.Assets.analysisLoading.swiftUIImage
        
        VStack(spacing: 5) {
          Text("나의 테이스팅 노트를")
            .foregroundColor(.white)
          Text("분석중이에요!")
            .foregroundColor(.white)
          
          Spacer()
        }
        .padding(.top, 18)
        .wineyFont(.title2)
      }
      .padding(.top, 21)
      .frame(maxHeight: .infinity)
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
    .onAppear {
      // loading 확인 딜레이
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        viewStore.send(._onAppear)
      }
    }
  }
}


public struct WineAnalysisLoadingView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisLoadingView(
      store: Store(
        initialState: WineAnalysisLoading.State(),
        reducer: {
          WineAnalysisLoading()
        }
      )
    )
  }
}
