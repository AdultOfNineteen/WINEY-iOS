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
  @ObservedObject var viewStore: ViewStoreOf<SmellList>
  
  public init(store: StoreOf<SmellList>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Text(viewStore.wineName)
          .wineyFont(.subhead)
          .foregroundStyle(viewStore.isOpenList ? WineyKitAsset.gray300.swiftUIColor : WineyKitAsset.gray600.swiftUIColor)
        
        Image(viewStore.isOpenList ? "smellPlusOpen" : "smellPlusDefault")
        
        Spacer()
      }
      .onTapGesture {
        viewStore.send(.tappedButton)
      }
      
      if viewStore.isOpenList {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 5) {
            ForEach(viewStore.smellList, id: \.self) { smell in
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
      .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      .background(
        Capsule()
          .stroke(WineyKitAsset.gray900.swiftUIColor)
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
