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
  
  public init(store: StoreOf<SettingTaste>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .clear
      )
      
      header()
      
      contentList()
      
      Spacer()
      
      WineyConfirmButton(title: "다음", validBy: store.finish > 0) {
        store.send(.tappedNextButton)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.top, 20)
      .padding(.bottom, WineyGridRules.bottomButtonPadding)
    }
    .background(
      .wineyMainBackground
    )
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension SettingTasteView {
  
  @frozen private enum TasteCategory {
    case sweetness
    case acidity
    case body
    case tannin
    case alcohol
    case sparkling
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
      case .sparkling:
        return "탄산감"
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
        return "알코올 향과 맛의 정도"
      case .sparkling:
        return "탄산의 세기"
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
        .foregroundStyle(.wineyGray50)
      
      Spacer()
      
      Text("맛 표현이 어려워요!")
        .underline()
        .foregroundStyle(.wineyGray500)
        .wineyFont(.captionM3)
        .offset(y: 2)
        .onTapGesture {
          store.send(.tappedHelpButton)
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
        LazyVStack(spacing: 37) {
          content(category: .sweetness, value: store.sweetness)
            .onChange(of: store.sweetness, perform: { [sweetness = store.sweetness] value in
              if sweetness == 0 && value > 0 {
                proxy.scrollTo(1, anchor: .bottom)
              }
            })
            .id(0)
          
          content(category: .acidity, value: store.acidity)
            .opacity(store.sweetness > 0 ? 1.0 : 0.0)
            .onChange(of: store.acidity, perform: { [acidity = store.acidity] value in
              if acidity == 0 && value > 0 {
                proxy.scrollTo(2, anchor: .bottom)
              }
            })
            .id(1)
          
          content(category: .body, value: store.body)
            .opacity(store.acidity > 0 ? 1.0 : 0.0)
            .onChange(of: store.body, perform: { [body = store.body] value in
              if body == 0 && value > 0 {
                proxy.scrollTo(3, anchor: .bottom)
              }
            })
            .id(2)
          
          content(category: .tannin, value: store.tannin)
            .opacity(store.body > 0 ? 1.0 : 0.0)
            .onChange(of: store.body, perform: { [tannin = store.tannin] value in
              if tannin == 0 && value > 0 {
                proxy.scrollTo(4, anchor: .bottom)
              }
            })
            .id(3)
          
          if CreateNoteManager.shared.isSparkling {
            content(category: .sparkling, value: store.sparkling)
              .opacity(store.tannin > 0 ? 1.0 : 0.0)
              .onChange(of: store.sparkling, perform: { [sparkling = store.sparkling] value in
                if sparkling == 0 && value > 0 {
                  proxy.scrollTo(5, anchor: .bottom)
                }
              })
              .id(4)
          } else {
            content(category: .alcohol, value: store.alcohol)
              .opacity(store.tannin > 0 ? 1.0 : 0.0)
              .onChange(of: store.alcohol, perform: { [alcohol = store.alcohol] value in
                if alcohol == 0 && value > 0 {
                  proxy.scrollTo(5, anchor: .bottom)
                }
              })
              .id(4)
          }
          
          content(category: .finish, value: store.finish)
            .opacity((CreateNoteManager.shared.isSparkling ? store.sparkling : store.alcohol) > 0 ? 1.0 : 0.0)
            .onChange(of: store.finish, perform: { [finish = store.finish] value in
              if finish == 0 && value > 0 {
                proxy.scrollTo(5, anchor: .bottom)
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
          .foregroundStyle(.wineyGray500)
        
        Text("・")
          .wineyFont(.captionB1)
          .foregroundStyle(.white)
        
        Text(category.description)
          .wineyFont(.captionB1)
          .foregroundStyle(.wineyGray600)
        
        Spacer()
      }
      
      HStack {
        Text("낮음")
        
        Spacer()
        
        Text("높음")
      }
      .wineyFont(.captionM1)
      .foregroundStyle(.wineyGray600)
      
      ZStack(alignment: .leading) {
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(height: 1)
          .foregroundStyle(.wineyGray800)
          .overlay(
            HStack {
              ForEach(1..<6) { index in
                Circle()
                  .frame(width: 14, height: 14)
                  .foregroundStyle(index <= value ? .wineyMain2 : .wineyGray800)
                  .onTapGesture {
                    switch category {
                    case .sweetness:
                      store.send(._setSweetness(index))
                    case .acidity:
                      store.send(._setAcidity(index))
                    case .body:
                      store.send(._setBody(index))
                    case .tannin:
                      store.send(._setTannin(index))
                    case .sparkling:
                      store.send(._setSparkling(index))
                    case .alcohol:
                      store.send(._setAlcohol(index))
                    case .finish:
                      store.send(._setFinish(index))
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
          .foregroundStyle(.wineyMain2)
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
