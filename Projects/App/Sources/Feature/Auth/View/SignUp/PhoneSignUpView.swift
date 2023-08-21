//
//  SignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct SignUpView: View {
  private let store: Store<PhoneSignUpState, PhoneSignUpAction>
  
  public init(store: Store<PhoneSignUpState, PhoneSignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        GeometryReader {_ in
          VStack {
            NavigationBar(
              leftIcon: Image(systemName: "arrow.backward"),
              leftIconButtonAction: {
                viewStore.send(.tappedBackButton)
              })
            
            Text("휴대폰 번호를 입력해주세요")
            
            CustomTextField(
              mainTitle: "휴대폰 번호",
              errorMessage: "올바른 번호를 입력해주세요",
              inputText: viewStore.binding(
                get: { $0.inputPhoneNumber },
                send: PhoneSignUpAction.edited
              ),
              textStyle: formatPhoneNumber(_:),
              maximumInputCount: 13,
              isInputTextCompleteCondition: { text in
                text.count == 13
              },
              onEditingChange: { }
            )
            
            WineyConfirmButton(
              title: "다음",
              validBy:
                viewStore.state.validPhoneNumber,
              action: {
                viewStore.send(.tappedNextButton)
              }
            )
            Spacer()
          }
        }
        .bottomSheet(
          backgroundColor: Color.black,
          isPresented: viewStore.binding(
            get: \.isPresentedBottomSheet,
            send: .tappedOutsideOfBottomSheet
          ),
          headerArea: { Text("헤더") },
          content: {
            Text("인증번호가 발송되었어요\n3분 안에 인증번호를 입력해주세요")
              .foregroundColor(.white)
          },
          bottomArea: {
            WineyConfirmButton(
              title: "확인",
              validBy: true,
              action: {
                viewStore.send(.tappedBottomCodeSendConfirmButton)
              }
            )
          }
        )
      }
      .navigationBarHidden(true)

    }
  
  func formatPhoneNumber(_ number: String) -> String {
    var digits = number.filter { $0.isNumber }
    if digits.count > 3 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
    }
    if digits.count > 8 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 8))
    }
    return String(digits)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: Store<PhoneSignUpState, PhoneSignUpAction>(
        initialState: .init(),
        reducer: setPhoneSignUpReducer,
        environment: SetPhoneSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
