//
//  TipCardListView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TipCardListView: View {
  private let store: StoreOf<TipCardList>
  
  public init(store: StoreOf<TipCardList>) {
    self.store = store
  }
  
  let columns = [GridItem(.flexible(), spacing: 17), GridItem(.flexible())]
  
  public var body: some View {
    VStack(spacing: 0) {
      if store.isShowNavigationBar {
        NavigationBar(
          title: "와인 초보를 위한",
          coloredTitle: "TIP",
          leftIcon: Image(.navigationBack_buttonW),
          leftIconButtonAction: {
            store.send(.tappedBackButton)
          },
          backgroundColor: Color.wineyMainBackground
        )
      }
      
      if !store.tipCard.isEmpty {
        ScrollView {
          LazyVGrid(columns: columns, spacing: 2) {
            ForEachStore(
              store.scope(state: \.tipCard, action: \.tipCard)
            ) { store in
              TipCardView(store: store)
                .onAppear {
                  // TODO: Pagination
                  //              if self.store.tipCard.contents[self.store.tipCard.contents.count - 1] == store.data {
                  //                store.send(._fetchNextTipCardPage)
                  //              }
                }
            }
          }
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(.wineyMainBackground)
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

public struct TipCardView_Previews: PreviewProvider {
  public static var previews: some View {
    TipCardListView(
      store: Store(
        initialState: TipCardList.State(
          //          tipCards: WineTipDTO(
          //            isLast: false,
          //            totalCnt: 1,
          //            contents: [
          //              WineTipContent(
          //                wineTipId: 1,
          //                thumbNail: "https://winey-image.s3.ap-northeast-2.amazonaws.com/wine-tip/11/99f6f17f-7091-4bf8-8640-429002298b13.jpg",
          //                title: "test",
          //                url: "test"
          //              )
          //            ]
          //          )
        ),
        reducer: {
          TipCardList()
        }
      )
    )
  }
}
