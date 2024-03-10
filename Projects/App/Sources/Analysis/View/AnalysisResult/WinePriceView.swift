//
//  WinePriceView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct WinePriceView: View {
  private let store: StoreOf<WinePrice>
  @ObservedObject var viewStore: ViewStoreOf<WinePrice>
  
  public init(store: StoreOf<WinePrice>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisTitle(title: viewStore.title)
        .wineyFont(.title2)
        .padding(.top, 66)
      
      contents()
      
      Spacer()
    }
  }
}

extension WinePriceView {
  
  @ViewBuilder
  private func contents() -> some View {
    ZStack {
      background()
      
      VStack(spacing: 0) {
        if viewStore.average > 0 {
          Text(viewStore.secondTitle)
            .wineyFont(.captionB1)
            .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
        }
        
        Text(viewStore.average == 0 ? "가격 정보가 없어요 :(" : "\(viewStore.average) 원")
          .wineyFont(viewStore.average == 0 ? .title2 : .title1)
          .foregroundColor(viewStore.average == 0 ? WineyKitAsset.gray600.swiftUIColor : WineyKitAsset.gray50.swiftUIColor)
          .padding(.top, 6)
      }
    }
    .frame(height: 324)
    .frame(maxWidth: .infinity)
    .opacity(viewStore.opacity)
    .padding(.top, 16)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onAppear {
      viewStore.send(._onAppear, animation: .easeIn(duration: 1.0))
    }
  }
  
  @ViewBuilder
  private func background() -> some View {
    ZStack {
      Circle()
        .fill(Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.5))
        .frame(width: UIScreen.main.bounds.width / 3)
        .blur(radius: 40)
    }
  }
}


struct WinePriceView_Previews: PreviewProvider {
  static var previews: some View {
    WinePriceView(
      store: Store(
        initialState: WinePrice.State.init(
          price: 30000
        ),
        reducer: {
          WinePrice()
        })
    )
  }
}
