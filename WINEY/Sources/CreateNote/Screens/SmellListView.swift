//
//  SmellListView.swift
//  Winey
//
//  Created by 정도현 on 1/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SmellListView: View {
  private let store: StoreOf<SmellList>
  
  public init(store: StoreOf<SmellList>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Text(store.wineName)
          .wineyFont(.subhead)
          .foregroundStyle(store.isOpenList ? .wineyGray300 : .wineyGray600)
        
        Image(store.isOpenList ? "smellPlusOpen" : "smellPlusDefault")
        
        Spacer()
      }
      .onTapGesture {
        store.send(.tappedButton)
      }
      
      if store.isOpenList {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 5) {
            ForEach(store.smellList, id: \.self) { smell in
              smellCapsule(text: smell)
            }
          }
        }
      }
    }
  }
}

extension SmellListView {
  
  @ViewBuilder
  private func smellCapsule(text: String) -> some View {
    Text(text)
      .wineyFont(.captionM1)
      .foregroundStyle(.wineyGray700)
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      .background(
        Capsule()
          .stroke(.wineyGray900)
      )
      .padding(1)
  }
}

#Preview {
  SmellListView(
    store: Store(
      initialState: SmellList.State(wineName: "test", smellList: ["test", "test"], type: .red),
      reducer: {
        SmellList()
      }
    )
  )
}
