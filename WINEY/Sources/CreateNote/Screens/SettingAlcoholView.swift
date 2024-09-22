//
//  SettingAlcoholView.swift
//  Winey
//
//  Created by 정도현 on 11/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SettingAlcoholView: View {
  private let store: StoreOf<SettingAlcohol>
  
  public init(store: StoreOf<SettingAlcohol>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      topView()
      
      Divider()
        .frame(height: 4)
        .overlay(
          .wineyGray900
        )
      
      alcoholValueView()
      
      Spacer()
      
      BottomOptionButton(
        validation: store.buttonState,
        tooltipVisible: store.tooltipVisible,
        action: { store.send(.tappedNextButton) },
        skipAction: { store.send(.tappedSkipButton) }
      )
    }
    .popGestureDisabled()
    .bottomSheet(
      backgroundColor: Color.wineyGray950,
      isPresented: .init(
        get: { store.isPresentedBottomSheet },
        set: { _ in store.send(.tappedOutsideOfBottomSheet) }
      ),
      headerArea: {
        Image(.noteColorImageW)
      },
      content: {
        bottomSheetText()
      },
      bottomArea: {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: {
            store.send(._presentBottomSheet(false))
          },
          rightTitle: "네, 지울래요",
          rightAction: {
            store.send(._deleteNote)
          }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .background(
      .wineyMainBackground
    )
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension SettingAlcoholView {
  
  @ViewBuilder
  private func topView() -> some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: { store.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      Spacer()
      
      VStack(spacing: 10) {
        Text("와인의 기본 정보를 알려주세요!")
          .foregroundStyle(.wineyGray400)
          .wineyFont(.bodyB1)
        
        Text("다음 구매시 참고를 돕고 추천해드릴게요!")
          .foregroundStyle(.wineyGray700)
          .wineyFont(.captionB1)
      }
      .padding(.bottom, 29)
    }
    .frame(height: 312)
    .background(
      Image(.wineTicketImageW)
        .resizable()
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    )
  }
  
  @ViewBuilder
  private func alcoholValueView() -> some View {
    VStack(spacing: 20) {
      Text("도수를 입력해주세요!")
        .wineyFont(.bodyB1)
      
      Picker(
        "",
        selection: .init(
          get: { store.alcoholValue },
          set: { value in store.send(.selectAlcoholValue(value)) }
        )
      ) {
        ForEach(store.alcoholValueRange, id: \.self) { number in
          Text("\(number)")
            .wineyFont(.title1)
        }
      }
      .pickerStyle(WheelPickerStyle())
      .frame(height: store.pickerHeight)
      .overlay(
        Circle()
          .fill(.wineyGray500)
          .frame(width: 7)
          .overlay(
            Circle()
              .fill(.wineyMainBackground)
              .frame(width: 3)
          )
          .padding(.leading, 50)
          .padding(.bottom, 12)
      )
    }
    .padding(.top, 49)
  }
  
  @ViewBuilder
  private func bottomSheetText() -> some View {
    VStack(spacing: 2.4) {
      Text("테이스팅 노트를 그만두시겠어요?")
        .foregroundColor(.wineyGray200)
      Text("삭제한 노트는 복구할 수 없어요 :(")
        .foregroundColor(.wineyGray600)
    }
    .wineyFont(.bodyB1)
  }
}

#Preview {
  SettingAlcoholView(
    store: Store(
      initialState: SettingAlcohol.State(),
      reducer: { SettingAlcohol() }
    )
  )
}
