//
//  ChangeNicknameView.swift
//  Winey
//
//  Created by 정도현 on 3/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct ChangeNicknameView: View {
  private let store: StoreOf<ChangeNickname>
  @ObservedObject var viewStore: ViewStoreOf<ChangeNickname>
  
  public init(store: StoreOf<ChangeNickname>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigationBar()
      
      title()
      
      textField()
      
      Spacer()
      
      bottomButton()
    }
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension ChangeNicknameView {
  
  @ViewBuilder
  private func navigationBar() -> some View {
    NavigationBar(
      leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
    )
  }
  
  @ViewBuilder
  private func title() -> some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("닉네임을 변경해주세요")
        .wineyFont(.title1)
        .foregroundStyle(.white)
      
      Text("언제든지 다시 바꿀 수 있어요!")
        .wineyFont(.bodyM2)
        .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func textField() -> some View {
    CustomTextField(
      mainTitle: "닉네임",
      placeholderText: "9자리 입력",
      errorMessage: "최대 9자로 입력해주세요.",
      inputText: viewStore.binding(
        get: { $0.userInput },
        send: ChangeNickname.Action.textEdit
      ),
      textStyle: { $0 },
      maximumInputCount: 50,
      completeCondition: !viewStore.userInput.isEmpty && viewStore.userInput.count <= 9,
      textDeleteButton: Image("text_delete_icon"),
      keyboardType: .default,
      onEditingChange: { }
    )
    .padding(.top, 30)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func bottomButton() -> some View {
    WineyConfirmButton(
      title: "변경",
      validBy: viewStore.buttonValidation
    ) {
      viewStore.send(.tappedChangeButton)
    }
    .padding(.bottom, WineyGridRules.bottomButtonPadding)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
}

#Preview {
  UserBadgeView(
    store: .init(
      initialState: .init(userId: 1),
      reducer: {
        UserBadge()
      }
    )
  )
}
