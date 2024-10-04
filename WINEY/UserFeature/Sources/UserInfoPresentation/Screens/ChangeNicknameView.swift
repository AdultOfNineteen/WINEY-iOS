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
  let store: StoreOf<ChangeNickname>
  
  public init(store: StoreOf<ChangeNickname>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigationBar()
      
      title()
      
      textField()
      
      Spacer()
      
      bottomButton()
    }
    .background(.wineyMainBackground)
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension ChangeNicknameView {
  
  @ViewBuilder
  private func navigationBar() -> some View {
    NavigationBar(
      leftIcon: Image(.navigationBack_buttonW),
      leftIconButtonAction: {
        store.send(.tappedBackButton)
      },
      backgroundColor: .wineyMainBackground
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
        .foregroundStyle(.wineyGray700)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func textField() -> some View {
    CustomTextField(
      mainTitle: "닉네임",
      placeholderText: "9자리 입력",
      errorMessage: "최대 9자로 입력해주세요.",
      inputText: .init(get: {
        store.userInput
      }, set: { edit in
        store.send(.textEdit(inputText: edit))
      }),
      textStyle: { $0 },
      maximumInputCount: 50,
      completeCondition: !store.userInput.isEmpty && store.userInput.count <= 9,
      textDeleteButton: Image(.text_delete_iconW),
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
      validBy: store.buttonValidation
    ) {
      store.send(.tappedChangeButton)
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
