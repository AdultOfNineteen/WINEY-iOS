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
  @ObservedObject var viewStore: ViewStoreOf<SettingAlcohol>
  
  public init(store: StoreOf<SettingAlcohol>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      topView()
      
      Divider()
        .frame(height: 4)
        .overlay(
          WineyKitAsset.gray900.swiftUIColor
        )
      
      alcoholValueView()
      
      Spacer()
      
      BottomOptionButton(
        validation: viewStore.buttonState,
        tooltipVisible: viewStore.tooltipVisible,
        action: { viewStore.send(.tappedNextButton) },
        skipAction: { viewStore.send(.tappedSkipButton) }
      )
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ),
      headerArea: {
        WineyAsset.Assets.noteColorImage.swiftUIImage
      },
      content: {
        bottomSheetText()
      },
      bottomArea: {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: {
            viewStore.send(._presentBottomSheet(false))
          },
          rightTitle: "네, 지울래요",
          rightAction: {
            viewStore.send(._deleteNote)
          }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension SettingAlcoholView {
  
  @ViewBuilder
  private func topView() -> some View {
    VStack {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: { viewStore.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      Spacer()
      
      VStack(spacing: 9) {
        Text("와인의 기본 정보를 알려주세요!")
          .foregroundStyle(WineyKitAsset.gray400.swiftUIColor)
          .wineyFont(.bodyB1)
        
        Text("다음 구매시 참고를 돕고 추천해드릴게요!")
          .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
          .wineyFont(.captionB1)
      }
      .padding(.bottom, 29)
    }
    .frame(height: 312)
    .background(
      WineyAsset.Assets.wineTicketImage.swiftUIImage
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
        selection: viewStore.binding(
          get: \.alcoholValue,
          send: SettingAlcohol.Action.selectAlcoholValue
        )
      ) {
        ForEach(viewStore.alcoholValueRange, id: \.self) { number in
          Text("\(number)")
            .wineyFont(.title1)
        }
      }
      .pickerStyle(WheelPickerStyle())
      .frame(height: viewStore.pickerHeight)
      .overlay(
        Circle()
          .fill(WineyKitAsset.gray500.swiftUIColor)
          .frame(width: 7)
          .overlay(
            Circle()
              .fill(WineyKitAsset.mainBackground.swiftUIColor)
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
        .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
      Text("삭제한 노트는 복구할 수 없어요 :(")
        .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
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
