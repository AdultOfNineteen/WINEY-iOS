//
//  WineCardListView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/25.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineCardListView: View {
  private let store: Store<WineCardListState, WineCardListAction>
  @GestureState var offset: CGFloat = 0
  @State var currentIdx = 0
  
  public init(store: Store<WineCardListState, WineCardListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { geo in
        let width = geo.size.width - (100 - 14)   // 22는 trailing Space
        
        // 카드 축소 반영 spacing
        HStack(spacing: 14) {
          ForEach(viewStore.state.wineList.indices, id: \.self) { index in
            let isSelected = index == currentIdx
            
            WineCard(wineData: viewStore.state.wineList[index])
              .frame(width: 282, height: 392)
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
              
              currentIdx = max(min(currentIdx + Int(roundIndex), viewStore.state.wineList.count - 1), 0)
            })
        )
      }
      .animation(.easeInOut, value: offset == 0)
    }
    .frame(height: 402)
  }
}
