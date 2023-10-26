//
//  NoteFilterView.swift
//  Winey
//
//  Created by 정도현 on 10/23/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteFilterView: View {
  private let store: StoreOf<NoteFilter>
  @ObservedObject var viewStore: ViewStoreOf<NoteFilter>
  
  public init(store: StoreOf<NoteFilter>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    Button(
      action: {
        viewStore.send(.tappedFilter)
      },
      label: {
        HStack(spacing: 4) {
          Text(viewStore.filterInfo.title)
            .foregroundColor(viewStore.filterInfo.isSelected ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
          
          if viewStore.filterInfo.count.description != "0" {
            Text(viewStore.filterInfo.count > 100 ? "100+" : viewStore.filterInfo.count.description)
              .foregroundColor(viewStore.filterInfo.isSelected ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray500.swiftUIColor)
          }
        }
        .wineyFont(.captionB1)
        .padding(.vertical, 9.5)
        .padding(.horizontal, 10)
        .background(
          RoundedRectangle(cornerRadius: 42)
            .stroke(viewStore.filterInfo.isSelected ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray900.swiftUIColor)
        )
      }
    )
  }
}
