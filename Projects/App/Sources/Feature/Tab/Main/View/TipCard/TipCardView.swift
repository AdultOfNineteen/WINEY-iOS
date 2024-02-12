//
//  TipCardView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TipCardView: View {
  private let store: StoreOf<TipCard>
  @ObservedObject var viewStore: ViewStoreOf<TipCard>
  
  public init(store: StoreOf<TipCard>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        NavigationBar(
          title: "와인 초보를 위한",
          coloredTitle: "TIP",
          leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
        )
        
        if let tipCards = viewStore.tipCards {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
              ForEach(tipCards.contents, id: \.wineTipId) { tipCard in
                TipCardImage(tipCardInfo: tipCard)
                  .onTapGesture {
                    viewStore.send(.tappedTipCard(url: tipCard.url))
                  }
              }
            }
          }
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        } else {
          ProgressView()  // TODO: 에러처리.
        }
      }
      .background(WineyKitAsset.mainBackground.swiftUIColor)
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
  }
}

public struct TipCardView_Previews: PreviewProvider {
  public static var previews: some View {
    TipCardView(
      store: Store(
        initialState: TipCard.State(
          tipCards: WineTipDTO(
            isLast: false,
            totalCnt: 1,
            contents: [
              WineTipContent(
                wineTipId: 1,
                thumbNail: "https://winey-image.s3.ap-northeast-2.amazonaws.com/wine-tip/11/99f6f17f-7091-4bf8-8640-429002298b13.jpg",
                title: "test",
                url: "test"
              )
            ]
          )
        ),
        reducer: {
          TipCard()
        }
      )
    )
  }
}
