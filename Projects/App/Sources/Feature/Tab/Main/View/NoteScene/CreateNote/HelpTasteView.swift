//
//  HelpTasteView.swift
//  Winey
//
//  Created by 정도현 on 11/14/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct HelpTasteView: View {
  
  private let store: StoreOf<HelpTaste>
  @ObservedObject var viewStore: ViewStoreOf<HelpTaste>
  
  public init(store: StoreOf<HelpTaste>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      NavigationBar(
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: .clear
      )
      
      headerView()
      
      contentList()
    }
    .ignoresSafeArea(edges: .bottom)
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .navigationBarHidden(true)
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
  }
}

extension HelpTasteView {
  
  private enum DefaultTasteCategory {
    case sweetness
    case acidity
    case body
    case tannin
    
    public var title: String {
      switch self {
        
      case .sweetness:
        return "당도"
      case .acidity:
        return "산도"
      case .body:
        return "바디"
      case .tannin:
        return "탄닌"
      }
    }
    
    public var description: String {
      switch self {
        
      case .sweetness:
        return "단맛의 정도"
      case .acidity:
        return "신맛의 정도"
      case .body:
        return "농도와 질감의 정도"
      case .tannin:
        return "떫고 씁쓸함의 정도"
      }
    }
  }
}

extension HelpTasteView {
  
  @ViewBuilder
  private func headerView() -> some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("이 와인은")
      Text("이런 맛을 느껴볼 수 있어요!")
    }
    .wineyFont(.title2)
    .foregroundStyle(.white)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.top, 20)
  }
  
  @ViewBuilder
  private func contentList() -> some View {
    if let wineDetailData = viewStore.wineDetailData {
      VStack(spacing: 37) {
        content(category: .sweetness, value: wineDetailData.sweetness)
        content(category: .acidity, value: wineDetailData.acidity)
        content(category: .body, value: wineDetailData.body)
        content(category: .tannin, value: wineDetailData.tannins)
        
        Spacer()
      }
      .padding(.top, 30)
    } else {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  @ViewBuilder
  private func content(category: DefaultTasteCategory, value: Int) -> some View {
    VStack(alignment: .leading, spacing: 15) {
      HStack(spacing: 4) {
        Text(category.title)
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
        
        Text("・")
          .wineyFont(.captionB1)
          .foregroundStyle(.white)
        
        Text(category.description)
          .wineyFont(.captionB1)
          .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
        
        Spacer()
      }
      
      HStack {
        Text("낮음")
        
        Spacer()
        
        Text("높음")
      }
      .wineyFont(.captionM1)
      .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
      
      ZStack(alignment: .leading) {
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(height: 1)
          .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)
          .overlay(
            HStack {
              ForEach(1..<6) { index in
                Circle()
                  .frame(width: 14, height: 14)
                  .foregroundStyle(index <= value ? WineyKitAsset.gray500.swiftUIColor : WineyKitAsset.gray800.swiftUIColor)
                
                if index < 5 { Spacer() }
              }
            }
          )
          .compositingGroup()
        
        Rectangle()
          .frame(height: 1)
          .frame(width: CGFloat(value - 1) * ((UIScreen.main.bounds.width - 48) / 4))
          .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
      }
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
}

#Preview {
  HelpTasteView(
    store: Store(
      initialState: HelpTaste.State(wineId: 1),
      reducer: {
        HelpTaste()
      }
    )
  )
}
