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
        
        Spacer()
      }
    )
  }
}

// MARK: 필터 화면 최상단 혹은 스크롤 뷰에서 띄어주는 경우
public struct NoteFilterDisplayView: View {
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
          
          Text("x")
        }
        .wineyFont(.captionB1)
        .foregroundColor(.white)
        .padding(.vertical, 9.5)
        .padding(.horizontal, 10)
        .background(
          RoundedRectangle(cornerRadius: 42)
            .stroke(WineyKitAsset.gray900.swiftUIColor)
            .overlay(
              RoundedRectangle(cornerRadius: 42)
                .stroke(WineyKitAsset.gray900.swiftUIColor)
            )
        )
      }
    )
  }
}


public struct NoteFilterIndicatorView: View {
  public var title: String
  public var action: () -> Void
  
  public init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: action,
      label: {
        HStack(spacing: 4) {
          Text(title)
            .foregroundColor(title == "초기화" ? WineyKitAsset.gray200.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
          
          if title == "초기화" {
            Image("initArrow")
              .foregroundColor(title == "초기화" ? WineyKitAsset.gray500.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
          } else {
            Image(systemName: "chevron.down")
              .foregroundColor(title == "초기화" ? WineyKitAsset.gray500.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
          }
        }
        .wineyFont(.captionB1)
        .padding(.vertical, 9.5)
        .padding(.horizontal, 10)
        .background(
          RoundedRectangle(cornerRadius: 42)
            .stroke(WineyKitAsset.gray900.swiftUIColor)
        )
      }
    )
  }
}
