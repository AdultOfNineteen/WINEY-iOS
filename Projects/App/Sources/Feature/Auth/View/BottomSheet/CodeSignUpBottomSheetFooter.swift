//
//  CodeSignUpBottomSheetFotter.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct CodeSignUpBottomSheetFooter: View {
  private let store: StoreOf<CodeSignUp>
  
  
  init(store: StoreOf<CodeSignUp>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.bottomSheetType) { viewStore in
      VStack {
        if viewStore.state == .back {
          TwoOptionSelectorButtonView(
            leftTitle: "아니오",
            leftAction: {
              viewStore.send(._presentBottomSheet(false))
            },
            rightTitle: "예",
            rightAction: {
              viewStore.send(._backToFirstView)
            }
          )
        }
        
        if case .alreadySignUp = viewStore.state {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedBottomAlreadySignUpButton)
            }
          )
        }
        
        if viewStore.state == .codeFail {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedBottomFailConfirmButton)
            }
          )
        }
        
        if viewStore.state == .resendCode {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedBottomResendCodeButton)
            }
          )
        }
      }
    }
  }
}
