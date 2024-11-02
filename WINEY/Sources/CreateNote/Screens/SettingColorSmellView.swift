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
  
  @Bindable var store: StoreOf<SettingColorSmell>
  
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
    .sheet(
      isPresented: $store.isShowAddSmellSection,
      content: {
        ZStack(alignment: .top) {
          Color.wineyGray950.ignoresSafeArea(edges: .all)
          
          customSmellAddSection()
            .padding(
              .horizontal,
              WineyGridRules
                .globalHorizontalPadding
            )
        }
        .presentationDetents([.fraction(0.28)])
        .presentationDragIndicator(.visible)
      }
    )
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
    VStack(alignment: .leading, spacing: 0) {
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
      .padding(.bottom, 20)
      
      VStack(spacing: 25) {
        smellCategoryInfo(category: .fruit)
        smellCategoryInfo(category: .natural)
        smellCategoryInfo(category: .oak)
        smellCategoryInfo(category: .etc)
        
        if !store.userCustomSmell.isEmpty {
          smellCategoryInfo(category: .custom)
        }
      }
      .padding(.bottom, 25)
      
      Button {
        store.send(.tappedAddSmellButton)
      } label: {
        Text("향 추가하기")
          .wineyFont(.bodyM2)
          .foregroundStyle(.wineyMain2)
          .frame(maxWidth: .infinity)
          .frame(height: 47)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .stroke(.wineyMain2)
          )
          .tint(.wineyMain2)
      }
      .padding(.bottom, 40)
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
          if category != .custom {
            ForEach(category.list, id: \.codeName) { smell in
              CapsuleButton(
                title: smell.korName,
                validation: store.selectedSmell.contains { $0 == smell.codeName },
                action: {
                  store.send(.tappedSmell(smell.codeName))
                }
              )
            }
          } else {
            ForEach(store.userCustomSmell.sorted(), id: \.self) { smell in
              CapsuleButton(
                title: smell,
                validation: store.selectedCustomSmell.contains { $0 == smell },
                action: {
                  store.send(.tappedCustomSmell(smell))
                }
              )
            }
          }
        }
        .padding(1)
      }
    }
  }
  
  @ViewBuilder
  private func customSmellAddSection() -> some View {
    VStack(spacing: 32) {
      CustomTextField(
        mainTitle: "향 키워드",
        placeholderText: "와인의 향을 입력해주세요",
        errorMessage: "다른 키워드로 향을 표현해주세요",
        inputText: $store.userInputSmell,
        textStyle: { $0 },
        maximumInputCount: 7,
        showStringLength: true,
        completeCondition: store.userInputSmell.count > 0 && store.userInputSmell.count < 8,
        keyboardType: .default
      )
      
      WineyConfirmButton(
        title: "확인",
        validBy: store.userInputSmell.count > 0 && store.userInputSmell.count < 8,
        action: { store.send(.tappedConfirmAddSmellButton) }
      )
    }
    .padding(.top, 47)
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
