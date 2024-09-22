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
  
  public init(store: StoreOf<SettingColorSmell>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: { store.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      ScrollView {
        LazyVStack(spacing: 45) {
          wineColorSetting()
          wineSmellSetting()
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
      .padding(.top, 20)
      
      WineyConfirmButton(
        title: "다음",
        validBy: store.buttonState
      ) {
        store.send(.tappedNextButton)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.top, 20)
      .padding(.bottom, WineyGridRules.bottomButtonPadding)
    }
    .background(
      .wineyMainBackground
    )
    .navigationBarHidden(true)
    .onAppear {
      store.send(._viewWillAppear)
    }
  }
}

extension SettingColorSmellView {
  
  @ViewBuilder
  private func wineColorSetting() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("와인의 컬러는요?")
        .wineyFont(.bodyB1)
        .foregroundStyle(.wineyGray50)
        .padding(.bottom, 10)
      
      Text("드신 와인 색감에 맞게 핀을 설정해주세요!")
        .wineyFont(.bodyB2)
        .foregroundStyle(.wineyGray800)
        .padding(.bottom, 29)
      
      HStack(alignment: .center, spacing: 0) {
        Circle()
          .fill(RadialGradient(
            colors: [
              store.colorIndicator,
              store.colorIndicator.opacity(0.5),
              .clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 20)
          )
          .frame(width: 40, height: 40)
        
        Spacer()
          .frame(width: 10)
        
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
        Capsule()
          .fill(
            LinearGradient(
              colors: store.colorBarList,
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .frame(height: 10)
          .padding(.leading, 11)
        
        HStack {
          Circle()
            .foregroundColor(.white)
            .frame(width: 22, height: 22)
            .offset(x: store.sliderValue)
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged { value in
                  store.send(.dragSlider(value))
                }
            )
          
          Spacer()
        }
        .onAppear {
          store.send(._setMaxValue(geo))
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
          .foregroundStyle(.wineyGray50)
        
        Text("(선택)")
          .wineyFont(.bodyB2)
          .foregroundStyle(.wineyGray600)
        
        Spacer()
        
        Text("향 표현이 어려워요!")
          .underline()
          .foregroundStyle(.wineyGray500)
          .wineyFont(.captionM3)
          .offset(y: 2)
          .onTapGesture {
            store.send(.tappedHelpSmellButton)
          }
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
    VStack(alignment: .leading, spacing: 14) {
      Text(category.title)
        .wineyFont(.bodyB2)
        .foregroundStyle(.wineyGray500)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 7) {
          ForEach(category.list, id: \.codeName) { category in
            CapsuleButton(
              title: category.korName,
              validation: store.selectedSmell.contains { $0 == category.codeName },
              action: {
                store.send(.tappedSmellButton(category.codeName))
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
      initialState: SettingColorSmell.State(),
      reducer: {
        SettingColorSmell()
      }
    )
  )
}
