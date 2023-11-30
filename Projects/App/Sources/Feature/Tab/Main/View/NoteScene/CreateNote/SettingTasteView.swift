//
//  SettingTasteView.swift
//  Winey
//
//  Created by 정도현 on 11/13/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SettingTasteView: View {
  private let store: StoreOf<SettingTaste>
  @ObservedObject var viewStore: ViewStoreOf<SettingTaste>
  
  public init(store: StoreOf<SettingTaste>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: .clear
      )
      
      header()
      
      contentList()
      
      Spacer()
      
      WineyConfirmButton(title: "다음", validBy: viewStore.buttonState) {
        viewStore.send(.tappedNextButton)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.top, 20)
      .padding(.bottom, 54)
    }
    .ignoresSafeArea(edges: .bottom)
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .navigationBarHidden(true)
  }
}

extension SettingTasteView {
  
  private enum TasteCategory {
    case sweetness
    case acidity
    case body
    case tannin
    case alcohol
    case finish
    
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
      case .alcohol:
        return "알코올"
      case .finish:
        return "여운"
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
      case .alcohol:
        return "단맛의 정도"
      case .finish:
        return "마신 후 맛과 향이 지속되는 정도"
      }
    }
  }
}

extension SettingTasteView {
  
  @ViewBuilder
  private func header() -> some View {
    HStack(alignment: .center) {
      Text("와인의 맛은 어떠셨나요?")
        .wineyFont(.bodyB1)
        .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
      
      Spacer()
      
      Text("맛 표현이 어려워요!")
        .underline()
        .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
        .wineyFont(.captionM3)
        .offset(y: 2)
        .onTapGesture {
          viewStore.send(.tappedHelpButton)
        }
    }
    .padding(.bottom, 15)
    .padding(.top, 20)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func contentList() -> some View {
    ScrollViewReader { proxy in
      ScrollView {
        VStack(spacing: 37) {
          content(category: .sweetness, value: viewStore.sweetness)
            .onChange(of: viewStore.sweetness, perform: { [sweetness = viewStore.sweetness] value in
              if sweetness == 0 && value > 0 {
                proxy.scrollTo(1, anchor: .bottom)
              }
            })
            .id(0)
          
          content(category: .acidity, value: viewStore.acidity)
            .opacity(viewStore.sweetness > 0 ? 1.0 : 0.0)
            .onChange(of: viewStore.acidity, perform: { [acidity = viewStore.acidity] value in
              if acidity == 0 && value > 0 {
                proxy.scrollTo(2, anchor: .bottom)
              }
            })
            .id(1)
          
          content(category: .body, value: viewStore.body)
            .opacity(viewStore.acidity > 0 ? 1.0 : 0.0)
            .onChange(of: viewStore.body, perform: { [body = viewStore.body] value in
              if body == 0 && value > 0 {
                proxy.scrollTo(3, anchor: .bottom)
              }
            })
            .id(2)
          
          content(category: .tannin, value: viewStore.tannin)
            .opacity(viewStore.body > 0 ? 1.0 : 0.0)
            .onChange(of: viewStore.body, perform: { [tannin = viewStore.tannin] value in
              if tannin == 0 && value > 0 {
                proxy.scrollTo(4, anchor: .bottom)
              }
            })
            .id(3)
          
          content(category: .alcohol, value: viewStore.alcohol)
            .opacity(viewStore.tannin > 0 ? 1.0 : 0.0)
            .onChange(of: viewStore.alcohol, perform: { [alcohol = viewStore.alcohol] value in
              if alcohol == 0 && value > 0 {
                proxy.scrollTo(5, anchor: .bottom)
              }
            })
            .id(4)
          
          content(category: .finish, value: viewStore.finish)
            .opacity(viewStore.alcohol > 0 ? 1.0 : 0.0)
            .onChange(of: viewStore.alcohol, perform: { [finish = viewStore.finish] value in
              if finish == 0 && value > 0 {
                proxy.scrollTo(5, anchor: .bottom)
                viewStore.send(._setButtonState)
              }
            })
            .padding(.bottom, 17)
            .id(5)
        }
        .padding(.top, 15)
      }
    }
  }
  
  @ViewBuilder
  private func content(category: TasteCategory, value: Int) -> some View {
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
                  .foregroundStyle(index <= value ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray800.swiftUIColor)
                  .onTapGesture {
                    switch category {
                    case .sweetness:
                      viewStore.send(._setSweetness(index))
                    case .acidity:
                      viewStore.send(._setAcidity(index))
                    case .body:
                      viewStore.send(._setBody(index))
                    case .tannin:
                      viewStore.send(._setTannin(index))
                    case .alcohol:
                      viewStore.send(._setAlcohol(index))
                    case .finish:
                      viewStore.send(._setFinish(index))
                    }
                  }
                
                if index < 5 {
                  Spacer()
                }
              }
            }
          )
          .compositingGroup()
        
        Rectangle()
          .frame(height: 1)
          .frame(width: CGFloat(value - 1) * (UIScreen.main.bounds.width - 48) / 4)
          .foregroundStyle(WineyKitAsset.main2.swiftUIColor)
      }
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
}

#Preview {
  SettingTasteView(
    store: Store(
      initialState: SettingTaste.State(), 
      reducer: {
        SettingTaste()
      }
    )
  )
}
