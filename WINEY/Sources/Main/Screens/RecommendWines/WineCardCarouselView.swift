//
//  WineCardCarouselView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct WineCardCarouselView: View {
  private let store: StoreOf<WineCardCarousel>
  
  @GestureState var offset: CGFloat = 0
  @State var currentIdx = 0
  
  public init(store: StoreOf<WineCardCarousel>) {
    self.store = store
  }
  
  public var body: some View {
    GeometryReader { geo in
      let width = geo.size.width - (95 - 14)
      
      if !store.wineCards.isEmpty {
        // 카드 축소 반영 spacing
        LazyHStack(spacing: 14) {
          ForEachStore(
            store.scope(state: \.wineCards, action: \.wineCard)
          ) { store in
            let isSelected = store.id == currentIdx
            
            WineCardView(store: store)
              .frame(width: geo.size.width - 90, height: 392)
              .scaleEffect(isSelected ? 1.0 : 0.9)
              .animation(.spring(), value: isSelected)
          }
        }
        .offset(x: (CGFloat(currentIdx) * -width) + (currentIdx != 0 ? 25 : 0) + offset)
        .gesture(
          DragGesture()
            .updating($offset, body: { value, out, _ in
              out = value.translation.width
            })
            .onEnded({ value in
              let offsetX = value.translation.width
              let progress = -offsetX / width
              let roundIndex = progress.rounded()
              
              currentIdx = max(min(currentIdx + Int(roundIndex),  store.state.wineCards.count - 1), 0)
            })
        )
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
    .animation(.easeInOut, value: offset == 0)
    .frame(height: 402)
  }
}
