//
//  CodeSignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct CodeSignUpView: View {
  private let store: Store<CodeSignUpState, CodeSignUpAction>
  
  public init(store: Store<CodeSignUpState, CodeSignUpAction>) {
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
            
            Text("인증번호를 입력해주세요")
            
            CustomTextField(
              mainTitle: "인증번호",
              errorMessage: "인증번호를 확인해주세요",
              inputText: viewStore.binding(
                get: { $0.inputCode },
                send: CodeSignUpAction.edited
              ),
              textStyle: { $0 },
              maximumInputCount: 6,
              isInputTextCompleteCondition: { text in
                text.count == 6
              },
              onEditingChange: { }
            )
            
            WineyConfirmButton(
              title: "다음",
              validBy:
                viewStore.state.validCode,
              action: {
                viewStore.send(.tappedCodeConfirmButton)
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
          headerArea: {
            CodeSignUpBottomSheetHeader()
          },
          content: {
            CodeSignUpBottomSheetContent(
              store: store.scope(
                state: \.bottomSheetType,
                action: { CodeSignUpAction.tappedOutsideOfBottomSheet } // 양식 맞춤
              )
            )
          },
          bottomArea: {
            CodeSignUpBottomSheetFooter(
              store: store // 분리해서 넣는 게 좋을까 논의 
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

struct CodeSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    CodeSignUpView(
      store: Store<CodeSignUpState, CodeSignUpAction>(
        initialState: .init(),
        reducer: setCodeSignUpReducer,
        environment: SetCodeSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
