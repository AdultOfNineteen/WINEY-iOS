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

struct TipCardView: View {
  private let store: StoreOf<TipCard>
  @ObservedObject var viewStore: ViewStoreOf<TipCard>
  
  public init(store: StoreOf<TipCard>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        NavigationBar(
          title: "와인 초보를 위한 TIP",
          leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
        )
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewStore.cardList) { card in
              Button(action: {
                viewStore.send(.tapCard(card.id))
              }, label: {
                card.tipCardImage
              })
            }
          }
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
      .background(WineyKitAsset.mainBackground.swiftUIColor)
    }
  }
}

public struct TipCardView_Previews: PreviewProvider {
  public static var previews: some View {
    TipCardView(store: Store(initialState: TipCard.State.init(), reducer: {
      TipCard()
    }))
  }
}

