//
//  SettingColorSmell.swift
//  Winey
//
//  Created by 정도현 on 11/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SettingColorSmellView: View {
  
  private let store: StoreOf<SettingColorSmell>
  @ObservedObject var viewStore: ViewStoreOf<SettingColorSmell>
  
  public init(store: StoreOf<SettingColorSmell>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: { viewStore.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      ScrollView {
        VStack(spacing: 45) {
          wineColorSetting()
          wineSmellSetting()
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
      .padding(.top, 20)
      
      WineyConfirmButton(
        title: "다음",
        validBy: viewStore.buttonState
      ) {
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

extension SettingColorSmellView {
  private enum SmellCategory {
    case fruit
    case natural
    case oak
    case etc
    
    public var title: String {
      switch self {
        
      case .fruit:
        return "과일향"
      case .natural:
        return "내추럴"
      case .oak:
        return "오크향"
      case .etc:
        return "기타"
      }
    }
    
    public var list: [String] {
      switch self {
        
      case .fruit:
        return ["과일향", "베리류", "레몬/라임", "사과/배", "복숭아/자두"]
      case .natural:
        return ["꽃향", "풀/나무", "허브향"]
      case .oak:
        return ["오크향", "향신료", "견과류", "바닐라", "초콜릿"]
      case .etc:
        return ["부싯돌", "빵", "고무", "흙/재", "약품"]
      }
    }
  }
}

extension SettingColorSmellView {
  
  @ViewBuilder
  private func wineColorSetting() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("와인의 컬러는요?")
        .wineyFont(.bodyB1)
        .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        .padding(.bottom, 10)
      
      Text("드신 와인 색감에 맞게 핀을 설정해주세요!")
        .wineyFont(.bodyB2)
        .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)
        .padding(.bottom, 29)
      
      HStack(alignment: .center, spacing: 0) {
        Circle()
          .fill(RadialGradient(
            colors: [
              Color(red: 255/255, green: viewStore.colorValue/255, blue: viewStore.colorValue/255),
              Color(red: 255/255, green: viewStore.colorValue/255, blue: viewStore.colorValue/255).opacity(0.3)
            ],
            center: .center,
            startRadius: 0,
            endRadius: 20)
          )
          .frame(width: 40, height: 40)
        
        Spacer()
          .frame(width: 21)
        
        VStack {
          Spacer()
          wineColorSlider()
          Spacer()
        }
      }
      .padding(.leading, 5)
    }
  }
  
  @ViewBuilder
  private func wineColorSlider() -> some View {
    GeometryReader { geo in
      
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .fill(
            LinearGradient(
              colors: [
                Color(red: 255/255, green: 0/255, blue: 0/255),
                Color(red: 255/255, green: 255/255, blue: 255/255)
              ],
              startPoint: .leading,
              endPoint: .trailing)
          )
          .frame(height: 10)
        
        HStack {
          Circle()
            .foregroundColor(.white)
            .frame(width: 22, height: 22)
            .offset(x: viewStore.sliderValue)
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged { value in
                  viewStore.send(.dragSlider(value))
                }
            )
          
          Spacer()
        }
        .onAppear {
          viewStore.send(._viewWillAppear(geo))
        }
      }
    }
  }
  
  @ViewBuilder
  private func wineSmellSetting() -> some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .center) {
        Text("와인의 향은요?")
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        
        Text("(선택)")
          .wineyFont(.bodyB2)
          .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
        
        Spacer()
        
        Text("향 표현이 어려워요!")
          .underline()
          .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
          .wineyFont(.captionM3)
          .offset(y: 2)
      }
      
      VStack(spacing: 25) {
        smellCategoryInfo(category: .fruit)
        smellCategoryInfo(category: .natural)
        smellCategoryInfo(category: .oak)
        smellCategoryInfo(category: .etc)
      }
    }
  }
  
  @ViewBuilder
  private func smellCategoryInfo(category: SmellCategory) -> some View {
    VStack(alignment: .leading, spacing: 23) {
      Text(category.title)
        .wineyFont(.bodyB2)
        .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 7) {
          ForEach(category.list, id: \.self) { category in
            CapsuleButton(
              title: category,
              validation: viewStore.selectedSmell.contains { $0 == category },
              action: {
                viewStore.send(.tappedSmellButton(category))
              }
            )
          }
        }
        .padding(1)
      }
    }
  }
}

#Preview {
  SettingColorSmellView(
    store: Store(
      initialState: SettingColorSmell.State(
        wineId: 0,
        officialAlcohol: 0, 
        vintage: 0,
        price: 0
      ),
      reducer: {
        SettingColorSmell()
      }
    )
  )
}
