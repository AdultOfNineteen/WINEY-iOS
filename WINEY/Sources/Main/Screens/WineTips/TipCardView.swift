//
//  TipCardView.swift
//  Winey
//
//  Created by 정도현 on 12/23/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TipCardView: View {
  private let store: StoreOf<TipCard>
  
  public init(store: StoreOf<TipCard>) {
    self.store = store
  }
  
  public var body: some View {
    AsyncImage(url: URL(string: store.data.thumbNail)) { image in
      ZStack {
        image.resizable()
          .clipShape(
            RoundedRectangle(cornerRadius: 10)
          )
        
        VStack {
          Spacer()
          
          Text(store.data.title)
            .wineyFont(.captionB1)
            .lineLimit(2)
            .frame(alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.bottom, 13)
            .foregroundStyle(.wineyGray50)
        }
      }
      .frame(height: 140)
    } placeholder: {
      ProgressView()
    }
    .onTapGesture {
      store.send(.tappedCard)
    }
  }
}
