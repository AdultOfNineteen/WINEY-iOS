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
  
  public init(store: StoreOf<WinePrice>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisCategoryTitle(title: store.title)
        .wineyFont(.title2)
      
      contents()
        .frame(maxHeight: .infinity)
        .padding(.bottom, 60)
    }
    .padding(.top, 66)
  }
}

extension WinePriceView {
  
  @ViewBuilder
  private func contents() -> some View {
    ZStack {
      background()
      
      VStack(spacing: 0) {
        if store.average > 0 {
          Text(store.secondTitle)
            .wineyFont(.captionB1)
            .foregroundColor(.wineyGray600)
        }
        
        Text(store.average == 0 ? "가격 정보가 없어요 :(" : "\(store.average) 원")
          .wineyFont(store.average == 0 ? .title2 : .title1)
          .foregroundColor(
            store.average == 0 ? .wineyGray600 : .wineyGray50
          )
          .padding(.top, 6)
      }
    }
    .opacity(store.opacity)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onAppear {
      store.send(._onAppear, animation: .easeIn(duration: 1.0))
    }
  }
  
  @ViewBuilder
  private func background() -> some View {
    ZStack {
      Circle()
        .fill(
          RadialGradient(
            gradient: Gradient(stops: [
              .init(color: Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.5), location: 0.0),
              .init(color: Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.2), location: 0.2),
              .init(color: Color(red: 34/225, green: 3/225, blue: 49/225).opacity(0.1), location: 0.7),
              .init(color: .clear, location: 1)
            ]),
            center: .center,
            startRadius: 0,
            endRadius: UIScreen.main.bounds.width / 2.5
          )
        )
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
    .background(.wineyMainBackground)
  }
}
