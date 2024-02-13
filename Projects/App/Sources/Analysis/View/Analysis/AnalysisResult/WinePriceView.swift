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
    GeometryReader { geo in
      VStack(spacing: 0) {
        WineAnalysisTitle(title: viewStore.title)
          .wineyFont(.title2)
          .padding(.top, 66)
        
        contents()
        
        Spacer()
        
        WineyAsset.Assets.arrowTop.swiftUIImage
          .padding(.bottom, 64)
      }
      .frame(width: geo.size.width)
    }
  }
}

extension WinePriceView {
  
  @ViewBuilder
  private func contents() -> some View {
    GeometryReader { geo in
      ZStack {
        background()
        
        VStack(spacing: 0) {
          Text(viewStore.secondTitle)
            .wineyFont(.captionB1)
            .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          Text("\(viewStore.average) 원")
            .wineyFont(.title1)
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            .padding(.top, 6)
        }
      }
      .opacity(viewStore.opacity)
      .frame(width: geo.size.width, height: geo.size.height)
      .padding(.top, 10)
    }
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
