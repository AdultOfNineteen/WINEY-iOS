//
//  NoteFilterScrollView.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteFilterScrollView: View {
  private let store: StoreOf<NoteFilterScroll>
  @ObservedObject var viewStore: ViewStoreOf<NoteFilterScroll>
  
  public init(store: StoreOf<NoteFilterScroll>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    HStack {
      ScrollView(.horizontal) {
        ForEach(viewStore.selectedFilter, id: \.self) { filter in
          Text(filter.filterInfo.title)
        }
      }
      
      Divider()
        .overlay(WineyKitAsset.gray900.swiftUIColor)
      
      Button(action: {
        viewStore.send(.tappedFilterButton)
      }, label: {
        WineyAsset.Assets.filterIcon.swiftUIImage
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(
            Capsule()
              .fill(WineyKitAsset.point1.swiftUIColor)
          )
      })
    }
    .padding(.leading, 4)
    .padding(.trailing, 20)
  }
}
