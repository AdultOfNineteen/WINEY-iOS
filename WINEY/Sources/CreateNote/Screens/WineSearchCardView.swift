//
//  WineSearchCardView.swift
//  WINEY
//
//  Created by 정도현 on 9/29/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineSearchCardView: View {
  private let store: StoreOf<WineSearchCard>
  
  public init(store: StoreOf<WineSearchCard>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HighLightTextView(
        text: store.data.name,
        textColor: .white,
        font: .winey(.medium, size: 17),
        highlightText: store.searchString,
        highlightColor: Color(.wineyMain3)
      )
      .lineLimit(1)
      .truncationMode(.tail)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 20)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      Divider()
        .frame(height: 0.8)
        .overlay(.wineyGray900)
    }
    .background(.wineyMainBackground)
    .onTapGesture {
      store.send(.tappedWineCard)
    }
  }
}

#Preview {
  WineSearchCardView(
    store: Store(
      initialState: .init(
        data: WineSearchContent(
          wineId: 1,
          type: "test",
          country: "test",
          name: "test",
          varietal: "Test"
        ),
        searchString: "Test"
      ),
      reducer: {
        WineSearchCard()
      }
    )
  )
}
